import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/customer/customer_payments_screen.dart';

class CustomerPendingPaymentsScreen extends StatefulWidget {
  const CustomerPendingPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerPendingPaymentsScreen> createState() =>
      _CustomerPendingPaymentsScreenState();
}

class _CustomerPendingPaymentsScreenState
    extends State<CustomerPendingPaymentsScreen> {
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
              .collection('customers')
              .doc(userData?.uid)
              .collection('pendingPayments')
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
                          'Vehicle : ${paymentsDocs[index]['vehicleNumber']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Amount Payable: ₹${paymentsDocs[index]['totalCost']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed(
                            CustomerPaymentsScreen.routeName,
                            arguments: paymentsDocs[index],
                          ),
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Pay'),
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
