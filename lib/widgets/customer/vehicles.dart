import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/customer/customer_service_history_screen.dart';

class Vehicles extends StatefulWidget {
  const Vehicles({Key? key}) : super(key: key);

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  @override
  Widget build(BuildContext context) {
    final userData = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('customers')
              .doc(userData!.uid)
              .collection('vehiclesList')
              .snapshots(),
          builder: (ctx, vehicleSnapshot) {
            if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (vehicleSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No vehicles added'),
              );
            }
            final vehicleDocs = vehicleSnapshot.data!.docs;
            return ListView.builder(
              itemCount: vehicleDocs.length,
              itemBuilder: (ctx, index) {
                if (vehicleDocs[index]['userID'] == futureSnapshot.data!.uid) {
                  return Card(
                    child: SizedBox(
                      width: double.infinity,
                      height: 420,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image.network(
                              vehicleDocs[index]['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Owner name: ${vehicleDocs[index]['ownerName']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Vehicle Number: ${vehicleDocs[index]['vehicleNumber']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Vehicle Type: ${vehicleDocs[index]['vehicleType']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Vehicle Make: ${vehicleDocs[index]['vehicleMake']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Vehicle Model: ${vehicleDocs[index]['vehicleModel']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(
                              CustomerServiceHistoryScreen.routeName,
                              arguments: vehicleDocs[index]['vehicleNumber'],
                            ),
                            icon: const Icon(Icons.chevron_right),
                            label: const Text('View Service History'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            );
          },
        );
      },
    );
  }
}
