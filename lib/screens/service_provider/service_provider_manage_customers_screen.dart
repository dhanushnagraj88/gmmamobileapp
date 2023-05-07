import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import './service_provider_qr_scan_screen.dart';

class ServiceProviderManageCustomersScreen extends StatefulWidget {
  const ServiceProviderManageCustomersScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-add-customer-screen';

  @override
  State<ServiceProviderManageCustomersScreen> createState() =>
      _ServiceProviderManageCustomersScreenState();
}

class _ServiceProviderManageCustomersScreenState
    extends State<ServiceProviderManageCustomersScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  void _deleteCustomer(String spID, String docID) {
    FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(spID)
        .collection('customersList')
        .doc(docID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final userData = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManageYour Customers'),
      ),
      body: FutureBuilder(
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
                .doc(userData!.uid)
                .collection('customersList')
                .snapshots(),
            builder: (ctx, customersSnapshot) {
              if (customersSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (customersSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No customers added yet'),
                );
              }
              final customerDocs = customersSnapshot.data!.docs;

              return ListView.builder(
                itemCount: customerDocs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${customerDocs[index]['userName']}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Number: ${customerDocs[index]['phone']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Customer ID: ${customerDocs[index]['userID']}',
                          ),
                          // ElevatedButton.icon(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.keyboard_arrow_right),
                          //   label: const Text('View Details'),
                          // ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error),
                            onPressed: () => _deleteCustomer(
                                userData.uid, customerDocs[index].id),
                            icon: const Icon(Icons.delete),
                            label: const Text('Remove Customer'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .pushNamed(ServiceProviderQRScanScreen.routeName),
        label: Row(
          children: const [
            Icon(Icons.person_add_alt_1),
            SizedBox(
              width: 5,
            ),
            Text('Add Customer')
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
