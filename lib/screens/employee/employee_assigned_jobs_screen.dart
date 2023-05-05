import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeAssignedJobsScreen extends StatefulWidget {
  const EmployeeAssignedJobsScreen({
    Key? key,
    required this.garageEmployeeID,
    required this.employeeIDNumber,
  }) : super(key: key);

  final String garageEmployeeID;
  final String employeeIDNumber;
  @override
  State<EmployeeAssignedJobsScreen> createState() =>
      _EmployeeAssignedJobsScreenState();
}

class _EmployeeAssignedJobsScreenState
    extends State<EmployeeAssignedJobsScreen> {
  DocumentReference<Map<String, dynamic>>? employeeDetails;
  Stream<QuerySnapshot<Map<String, dynamic>>>? assignedJobDetails;
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
    final empRef = dummyData.reference;
    final jobDetails = empRef.collection('assignedJobs').snapshots();

    return [empRef, jobDetails, docRef];
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

  void _setAsOngoing(Map<String, dynamic> data, String id) async {
    final docRef = employeeDetails?.collection('ongoingJobs');
    await docRef?.doc(id).set(data);

    await employeeDetails
        ?.collection('ongoingJobs')
        .doc(id)
        .update({'jobStatus': 'Ongoing'});
    await employeeDetails?.collection('assignedJobs').doc(id).delete();
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeDetails().then((value) {
      setState(() {
        employeeDetails = value[0];
        assignedJobDetails = value[1];
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
          stream: assignedJobDetails,
          builder: (ctx, assignedJobSnapShots) {
            if (assignedJobSnapShots.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (assignedJobSnapShots.data == null) {
              return const Center(
                child: Text('No Assigned Jobs at the moment!'),
              );
            }
            if (assignedJobSnapShots.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Assigned Jobs at the moment!'),
              );
            }
            final assignedJobsDocs = assignedJobSnapShots.data!.docs;
            return ListView.builder(
              itemCount: assignedJobsDocs.length,
              itemBuilder: (ctx, index) {
                assignedJobsDocs[index].id;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${assignedJobsDocs[index]['jobTitle']}: ${assignedJobsDocs[index]['vehicleNumber']}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${assignedJobsDocs[index]['vehicleMake']} ${assignedJobsDocs[index]['vehicleModel']}',
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
                          assignedJobsDocs[index]['ownerName'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cost: ${assignedJobsDocs[index]['totalCost']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Duration: ${assignedJobsDocs[index]['totalDuration']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showDetails(
                            context,
                            assignedJobsDocs[index],
                          ),
                          child: const Text('Show Details'),
                        ),
                        ElevatedButton(
                          onPressed: () => _setAsOngoing(
                              assignedJobsDocs[index].data(),
                              assignedJobsDocs[index].id),
                          child: const Text('Set as Ongoing'),
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
