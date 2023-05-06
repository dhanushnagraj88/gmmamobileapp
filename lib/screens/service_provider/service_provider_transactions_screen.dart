import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderTransactionsScreen extends StatefulWidget {
  const ServiceProviderTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<ServiceProviderTransactionsScreen> createState() =>
      _ServiceProviderTransactionsScreenState();
}

class _ServiceProviderTransactionsScreenState
    extends State<ServiceProviderTransactionsScreen> {
  final userData = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
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
              .doc(userData?.uid)
              .collection('transactionsList')
              .snapshots(),
          builder: (ctx, transactionsSnapshot) {
            if (transactionsSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (transactionsSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Pending Transactions at the moment'),
              );
            }
            final transactionsDocs = transactionsSnapshot.data!.docs;
            return ListView.builder(
              itemCount: transactionsDocs.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Vehicle Number: ${transactionsDocs[index]['vehicleNumber']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Owner Name: ${transactionsDocs[index]['ownerName']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Amount Recieved: ${transactionsDocs[index]['totalCost']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
