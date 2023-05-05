import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeCompletedJobsScreen extends StatefulWidget {
  const EmployeeCompletedJobsScreen(
      {Key? key,
      required this.garageEmployeeID,
      required this.employeeIDNumber})
      : super(key: key);

  final String garageEmployeeID;
  final String employeeIDNumber;

  @override
  State<EmployeeCompletedJobsScreen> createState() =>
      _EmployeeCompletedJobsScreenState();
}

class _EmployeeCompletedJobsScreenState
    extends State<EmployeeCompletedJobsScreen> {
  DocumentReference<Map<String, dynamic>>? employeeDetails;
  Stream<QuerySnapshot<Map<String, dynamic>>>? completedJobDetails;
  DocumentReference<Map<String, dynamic>>? documentReference;
  Future<List<dynamic>> _getEmployeeDetails() async {
    final value = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .where('garageEmployeesID', isEqualTo: widget.garageEmployeeID)
        .get();

    final docRef = value.docs.first.reference;

    final dummyData = await docRef
        .collection('employeesList')
        .doc(widget.employeeIDNumber)
        .get();
    final completedJobsColl = docRef
        .collection('completedJobsList')
        .orderBy(
          'dateAdded',
          descending: true,
        )
        .snapshots();

    final empRef = dummyData.reference;
    final jobDetails = empRef.collection('completedJobs').snapshots();

    return [empRef, completedJobsColl, docRef];
  }

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
                      children: List.generate(
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
  void initState() {
    super.initState();
    _getEmployeeDetails().then((value) {
      setState(() {
        employeeDetails = value[0];
        completedJobDetails = value[1];
        documentReference = value[2];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(documentReference),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: completedJobDetails,
          builder: (ctx, completedJobSnapShots) {
            if (completedJobSnapShots.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (completedJobSnapShots.data == null) {
              return const Center(
                child: Text('No Completed Jobs at the moment!'),
              );
            }
            if (completedJobSnapShots.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Completed Jobs at the moment!'),
              );
            }
            // final completedJobsDocs = completedJobSnapShots.data!.docs;
            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                completedJobsDocs = [];
            for (var element in completedJobSnapShots.data!.docs) {
              if (element.data()['assignedTo'] == widget.employeeIDNumber) {
                completedJobsDocs.add(element);
              }
            }
            if (completedJobsDocs.isEmpty) {
              return const Center(
                child: Text('No Assigned Jobs at the moment!'),
              );
            }
            return ListView.builder(
              itemCount: completedJobsDocs.length,
              itemBuilder: (ctx, index) {
                completedJobsDocs[index].id;
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
              },
            );
          },
        );
      },
    );
  }
}
