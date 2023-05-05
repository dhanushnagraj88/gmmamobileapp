import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_choose_parts_and_services_screen.dart';

class ServiceProviderChooseVehicleScreen extends StatefulWidget {
  const ServiceProviderChooseVehicleScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-choose-vehicle-screen';

  @override
  State<ServiceProviderChooseVehicleScreen> createState() =>
      _ServiceProviderChooseVehicleScreenState();
}

class _ServiceProviderChooseVehicleScreenState
    extends State<ServiceProviderChooseVehicleScreen> {
  QuerySnapshot<Map<String, dynamic>>? _customersList;
  @override
  void initState() {
    // TODO: implement initState
    _getCustomersList();
    super.initState();
  }

  void _getCustomersList() async {
    User? user = FirebaseAuth.instance.currentUser;
    final customerData = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user?.uid)
        .collection('customersList')
        .get();
    setState(() {
      _customersList = customerData;
    });
    _getCustomerVehicles();
  }

  Future<List<Map<String, dynamic>>> _getCustomerVehicles() async {
    List<Map<String, dynamic>> vehiclesList = [];
    for (var element in _customersList!.docs) {
      final value = await FirebaseFirestore.instance
          .collection('customers')
          .doc(element.data()['userID'])
          .collection('vehiclesList')
          .get();
      vehiclesList.addAll(value.docs.map((e) => e.data()).toList());
    }
    return vehiclesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Vehicle'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getCustomerVehicles(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final vehiclesList = snapshot.data;
          return ListView.builder(
            itemCount: vehiclesList?.length ?? 0,
            itemBuilder: (ctx, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed(
                      ServiceProviderChoosePartsAndServicesScreen.routeName,
                      arguments: vehiclesList[index]),
                  title: Text(
                    vehiclesList![index]['vehicleNumber'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehiclesList[index]['ownerName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${vehiclesList[index]['vehicleType']}: ${vehiclesList[index]['vehicleMake']}  ${vehiclesList[index]['vehicleModel']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
