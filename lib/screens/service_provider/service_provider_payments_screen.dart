import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderPaymentsScreen extends StatefulWidget {
  const ServiceProviderPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<ServiceProviderPaymentsScreen> createState() =>
      _ServiceProviderPaymentsScreenState();
}

class _ServiceProviderPaymentsScreenState
    extends State<ServiceProviderPaymentsScreen> {
  final userData = FirebaseAuth.instance.currentUser;

  void _paymentsRecieved(Map<String, dynamic> data, String id) async {
    final docRef = FirebaseFirestore.instance.collection('serviceProviders');
    await docRef
        .doc(userData?.uid)
        .collection('transactionsList')
        .doc(id)
        .set(data);
    await docRef
        .doc(userData?.uid)
        .collection('pendingPaymentsList')
        .doc(id)
        .delete();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(data['userID'])
        .collection('pendingPayments')
        .where('dateAdded', isEqualTo: data['dateAdded'])
        .get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for (DocumentSnapshot document in documents) {
      await document.reference.delete();
    }
  }

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
              .collection('pendingPaymentsList')
              .snapshots(),
          builder: (ctx, paymentsSnapshot) {
            if (paymentsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (paymentsSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Pending Transactions at the moment'),
              );
            }
            final paymentsDocs = paymentsSnapshot.data!.docs;
            return ListView.builder(
              itemCount: paymentsDocs.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Vehicle Number: ${paymentsDocs[index]['vehicleNumber']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Owner Name: ${paymentsDocs[index]['ownerName']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Service Cost: ${paymentsDocs[index]['totalCost']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _paymentsRecieved(
                            paymentsDocs[index].data(),
                            paymentsDocs[index].id,
                          ),
                          child: const Text('Payment Recieved'),
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
    );
  }
}
