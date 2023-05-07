import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CustomerNearbyGarages extends StatefulWidget {
  const CustomerNearbyGarages({Key? key}) : super(key: key);

  @override
  State<CustomerNearbyGarages> createState() => _CustomerNearbyGaragesState();
}

class _CustomerNearbyGaragesState extends State<CustomerNearbyGarages> {
  User? userData = FirebaseAuth.instance.currentUser;
  Position? userCurrentLocation;
  int? distanceInMeters;

  Future<void> _getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied permanently');
    }

    final currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      userCurrentLocation = currentPosition;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userCurrentLocation == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return FutureBuilder(
      future: Future.value(userData),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('serviceProviders')
                .snapshots(),
            builder: (ctx, garagesSnapshot) {
              if (garagesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (garagesSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No nearby garages are available'),
                );
              }
              List<QueryDocumentSnapshot<Map<String, dynamic>>> nearbyGarages =
                  [];
              for (var element in garagesSnapshot.data!.docs) {
                GeoPoint garageLocation = element.data()['garageLocation'];
                distanceInMeters = Geolocator.distanceBetween(
                        userCurrentLocation!.latitude,
                        userCurrentLocation!.longitude,
                        garageLocation.latitude,
                        garageLocation.longitude)
                    .toInt();
                if (distanceInMeters!.toInt() < 5000) {
                  nearbyGarages.add(element);
                }
              }
              if (nearbyGarages.isEmpty) {
                return const Center(
                  child: Text('No Nearby Garages'),
                );
              }
              return ListView.builder(
                  itemCount: nearbyGarages.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Garage Name: ${nearbyGarages[index]['garageName']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Owner Name: ${nearbyGarages[index]['ownerName']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Phone Number: ${nearbyGarages[index]['phone']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Garage Address: ${nearbyGarages[index]['garageAddress']}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
      },
    );
  }
}
