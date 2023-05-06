import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeOngoingJobsScreen extends StatefulWidget {
  const EmployeeOngoingJobsScreen(
      {Key? key,
      required this.garageEmployeeID,
      required this.employeeIDNumber})
      : super(key: key);

  final String garageEmployeeID;
  final String employeeIDNumber;

  @override
  State<EmployeeOngoingJobsScreen> createState() =>
      _EmployeeOngoingJobsScreenState();
}

class _EmployeeOngoingJobsScreenState extends State<EmployeeOngoingJobsScreen> {
  DocumentReference<Map<String, dynamic>>? employeeDetails;
  Stream<QuerySnapshot<Map<String, dynamic>>>? ongoingJobDetails;
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
    final ongoingJobColl = docRef
        .collection('ongoingJobsList')
        .orderBy(
          'dateAdded',
          descending: true,
        )
        .snapshots();

    final empRef = dummyData.reference;
    final jobDetails = empRef.collection('ongoingJobs').snapshots();

    return [empRef, ongoingJobColl, docRef];
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

  void _setAsCompleted(Map<String, dynamic> data, String id) async {
    final docRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(documentReference?.id)
        .collection('completedJobsList');
    await docRef.doc(id).set(data);
    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(documentReference?.id)
        .collection('pendingPaymentsList')
        .add(data);
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(data['userID'])
        .collection('pendingPayments')
        .add(data);
    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(documentReference?.id)
        .collection('ongoingJobsList')
        .doc(id)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeDetails().then((value) {
      setState(() {
        employeeDetails = value[0];
        ongoingJobDetails = value[1];
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
          stream: ongoingJobDetails,
          builder: (ctx, ongoingJobSnapShots) {
            if (ongoingJobSnapShots.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (ongoingJobSnapShots.data == null) {
              return const Center(
                child: Text('No Ongoing Jobs at the moment!'),
              );
            }
            if (ongoingJobSnapShots.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Ongoing Jobs at the moment!'),
              );
            }
            // final ongoingJobsDocs = ongoingJobSnapShots.data!.docs;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> ongoingJobsDocs =
                [];
            for (var element in ongoingJobSnapShots.data!.docs) {
              if (element.data()['assignedTo'] == widget.employeeIDNumber) {
                ongoingJobsDocs.add(element);
              }
            }
            if (ongoingJobsDocs.isEmpty) {
              return const Center(
                child: Text('No Ongoing Jobs at the moment!'),
              );
            }
            return ListView.builder(
              itemCount: ongoingJobsDocs.length,
              itemBuilder: (ctx, index) {
                ongoingJobsDocs[index].id;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ongoingJobsDocs[index]['jobTitle']}: ${ongoingJobsDocs[index]['vehicleNumber']}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${ongoingJobsDocs[index]['vehicleMake']} ${ongoingJobsDocs[index]['vehicleModel']}',
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
                          ongoingJobsDocs[index]['ownerName'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cost: ${ongoingJobsDocs[index]['totalCost']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Duration: ${ongoingJobsDocs[index]['totalDuration']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showDetails(
                            context,
                            ongoingJobsDocs[index],
                          ),
                          child: const Text('Show Details'),
                        ),
                        ElevatedButton(
                          onPressed: () => _setAsCompleted(
                              ongoingJobsDocs[index].data(),
                              ongoingJobsDocs[index].id),
                          child: const Text('Set as Completed'),
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
