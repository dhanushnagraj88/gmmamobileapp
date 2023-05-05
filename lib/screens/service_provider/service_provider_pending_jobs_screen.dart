import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceProviderPendingJobsScreen extends StatefulWidget {
  const ServiceProviderPendingJobsScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-pending-jobs-screen';

  @override
  State<ServiceProviderPendingJobsScreen> createState() =>
      _ServiceProviderPendingJobsScreenState();
}

class _ServiceProviderPendingJobsScreenState
    extends State<ServiceProviderPendingJobsScreen> {
  final userData = FirebaseAuth.instance.currentUser;
  void _showDetails(
    BuildContext ctx,
    QueryDocumentSnapshot<Map<String, dynamic>> data,
  ) {
    List jobDetails = data['jobDetails'];
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Job Status: ${data['jobStatus']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Job Title: ${data['jobTitle']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Owner Name: ${data['ownerName']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vehicle Number: ${data['vehicleNumber']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vehicle Type: ${data['vehicleType']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vehicle Make: ${data['vehicleMake']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vehicle Model: ${data['vehicleModel']}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Job Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(
                          jobDetails.length,
                          (index) {
                            return Card(
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service/Part Name: ${jobDetails[index]['name']}',
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Cost: ${jobDetails[index]['cost']}',
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Process Duration: ${jobDetails[index]['cost']}',
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Card(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Added: ${DateFormat.yMMMd().add_jm().format(data['dateAdded'].toDate())}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Cost: ${data['totalCost']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Duration: ${data['totalDuration']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showListOfEmployees(
      BuildContext ctx, Map<String, dynamic> jobData, String docID) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return SingleChildScrollView(
          child: FutureBuilder(
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
                    .collection('employeesList')
                    .snapshots(),
                builder: (ctx, employeesSnapshot) {
                  if (employeesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (employeesSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No registered employees!'),
                    );
                  }
                  final employeeDocs = employeesSnapshot.data!.docs;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: employeeDocs.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Card(
                              margin: const EdgeInsets.all(7),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    employeeDocs[index]['employeeIDNumber'],
                                  ),
                                ),
                                title: Text(
                                  employeeDocs[index]['employeeName'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  employeeDocs[index]['employeeDesignation'],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    _assignTask(
                                      employeeDocs[index]['employeeIDNumber'],
                                      jobData,
                                      docID,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Assign'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _assignTask(
      String empID, Map<String, dynamic> jobData, String docID) async {
    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .collection('pendingJobsList')
        .doc(docID)
        .update({
      'assignedTo': empID,
    });
  }

  void _setAsOngoing(Map<String, dynamic> data, String id) async {
    final docRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .collection('ongoingJobsList');
    await docRef.doc(id).set(data);
    await docRef.doc(id).update({'jobStatus': 'Ongoing'});
    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .collection('pendingJobsList')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Jobs'),
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
                .collection('pendingJobsList')
                .orderBy(
                  'dateAdded',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, pendingJobsSnapshot) {
              if (pendingJobsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (pendingJobsSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Pending Jobs at the moment!'),
                );
              }
              final pendingJobsDocs = pendingJobsSnapshot.data!.docs;
              return ListView.builder(
                  itemCount: pendingJobsDocs.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pendingJobsDocs[index]['jobTitle']}: ${pendingJobsDocs[index]['vehicleNumber']}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${pendingJobsDocs[index]['vehicleMake']} ${pendingJobsDocs[index]['vehicleModel']}',
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
                              pendingJobsDocs[index]['ownerName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cost: ${pendingJobsDocs[index]['totalCost']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Duration: ${pendingJobsDocs[index]['totalDuration']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showDetails(
                                context,
                                pendingJobsDocs[index],
                              ),
                              child: const Text('Show Details'),
                            ),
                            ElevatedButton(
                              onPressed: () => _showListOfEmployees(
                                  context,
                                  pendingJobsDocs[index].data(),
                                  pendingJobsDocs[index].id),
                              child: const Text('Assign To'),
                            ),
                            ElevatedButton(
                              onPressed: () => _setAsOngoing(
                                pendingJobsDocs[index].data(),
                                pendingJobsDocs[index].id,
                              ),
                              child: const Text('Set as Ongoing'),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
