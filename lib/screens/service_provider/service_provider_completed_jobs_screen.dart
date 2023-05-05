import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceProviderCompletedJobsScreen extends StatefulWidget {
  const ServiceProviderCompletedJobsScreen({Key? key}) : super(key: key);
  static const routeName = '/service-provider-completed-jobs-screen';

  @override
  State<ServiceProviderCompletedJobsScreen> createState() =>
      _ServiceProviderCompletedJobsScreenState();
}

class _ServiceProviderCompletedJobsScreenState
    extends State<ServiceProviderCompletedJobsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Jobs'),
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
                .collection('completedJobsList')
                .orderBy(
                  'dateAdded',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, completedJobsSnapshot) {
              if (completedJobsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (completedJobsSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Pending Jobs at the moment!'),
                );
              }
              final completedJobsDocs = completedJobsSnapshot.data!.docs;
              return ListView.builder(
                  itemCount: completedJobsDocs.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${completedJobsDocs[index]['jobTitle']}: ${completedJobsDocs[index]['vehicleNumber']}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${completedJobsDocs[index]['vehicleMake']} ${completedJobsDocs[index]['vehicleModel']}',
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
                              completedJobsDocs[index]['ownerName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cost: ${completedJobsDocs[index]['totalCost']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Duration: ${completedJobsDocs[index]['totalDuration']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showDetails(
                                context,
                                completedJobsDocs[index],
                              ),
                              child: const Text('Show Details'),
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
