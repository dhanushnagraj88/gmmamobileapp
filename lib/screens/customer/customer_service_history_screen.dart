import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerServiceHistoryScreen extends StatefulWidget {
  const CustomerServiceHistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/customer-service-history-screen';

  @override
  State<CustomerServiceHistoryScreen> createState() =>
      _CustomerServiceHistoryScreenState();
}

class _CustomerServiceHistoryScreenState
    extends State<CustomerServiceHistoryScreen> {
  String? _arguments;
  List<Map<String, dynamic>> serviceHistory = [];

  Future<void> searchTransactionsByVehicleName() async {
    final providers =
        await FirebaseFirestore.instance.collection('serviceProviders').get();

    for (final provider in providers.docs) {
      final transactions = await provider.reference
          .collection('transactionsList')
          .where('vehicleNumber', isEqualTo: _arguments)
          .get();
      for (final transaction in transactions.docs) {
        // Do something with the matching transaction document
        setState(() {
          serviceHistory.add(transaction.data());
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    searchTransactionsByVehicleName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;
    if (args == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (args != null) {
      setState(() {
        _arguments = args;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$_arguments Service History'),
      ),
      body: serviceHistory.isEmpty
          ? const Center(
              child: Text('No previous service history found'),
            )
          : ListView.builder(
              itemCount: serviceHistory.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Job Title: ${serviceHistory[index]['jobTitle']}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Service Cost: ${serviceHistory[index]['jobTitle']}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Performed On: ${DateFormat.yMMMd().add_jm().format(
                            serviceHistory[index]['dateAdded'].toDate(),
                          )}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
