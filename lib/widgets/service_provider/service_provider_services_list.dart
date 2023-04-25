import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderServicesList extends StatefulWidget {
  const ServiceProviderServicesList({Key? key}) : super(key: key);

  @override
  State<ServiceProviderServicesList> createState() =>
      _ServiceProviderServicesListState();
}

class _ServiceProviderServicesListState
    extends State<ServiceProviderServicesList> {
  final _formKey = GlobalKey<FormState>();
  User? userData;
  DocumentSnapshot<Map<String, dynamic>>? collectionsData;

  List<dynamic>? garageTypes = [];
  var _serviceName = '';
  var _serviceType = '';
  var _serviceCost = 0;
  var _serviceDuration = 0;

  Future<void> _getCurrentUserData() async {
    userData = FirebaseAuth.instance.currentUser;
    final collectionData = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .get();
    setState(() {
      garageTypes = collectionData['garageTypes'];
      collectionsData = collectionData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserData();
    super.initState();
  }

  void _addNewService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(bCtx).viewInsets.bottom + 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      key: const ValueKey('serviceName'),
                      decoration:
                          const InputDecoration(labelText: 'Service Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _serviceName = value!;
                      },
                    ),
                    DropdownButtonFormField(
                      key: const ValueKey('serviceType'),
                      items: garageTypes
                          ?.map((val) => DropdownMenuItem(
                                key: ValueKey(val),
                                value: val,
                                child: Text(val),
                              ))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Choose Service Type',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _serviceType = value as String;
                      },
                      onChanged: (newValue) => setState(() {
                        _serviceType = newValue as String;
                      }),
                    ),
                    TextFormField(
                      key: const ValueKey('serviceCost'),
                      decoration: const InputDecoration(
                        labelText: 'Service Cost',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _serviceCost = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('serviceDuration'),
                      decoration: const InputDecoration(
                        labelText: 'Service Duration in Hours',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _serviceDuration = int.parse(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _submitServiceForm(
                          name: _serviceName,
                          type: _serviceType,
                          cost: _serviceCost,
                          duration: _serviceDuration,
                          ctx: context,
                        );
                      },
                      child: const Text('Add Service'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editService(BuildContext context, Map<String, dynamic> docData) async {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(bCtx).viewInsets.bottom + 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      initialValue: docData['serviceName'],
                      key: const ValueKey('serviceName'),
                      decoration:
                          const InputDecoration(labelText: 'Service Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _serviceName = value!;
                      },
                    ),
                    DropdownButtonFormField(
                      key: const ValueKey('serviceType'),
                      value: docData['serviceType'],
                      items: garageTypes
                          ?.map((val) => DropdownMenuItem(
                                key: ValueKey(val),
                                value: val,
                                child: Text(val),
                              ))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Choose Service Type',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _serviceType = value as String;
                      },
                      onChanged: (newValue) => setState(() {
                        _serviceType = newValue as String;
                      }),
                    ),
                    TextFormField(
                      key: const ValueKey('serviceCost'),
                      initialValue: docData['serviceCost'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Service Cost',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _serviceCost = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('serviceDuration'),
                      initialValue: docData['serviceDuration'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Service Duration in Hours',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _serviceDuration = int.parse(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _editServiceForm(
                          name: _serviceName,
                          type: _serviceType,
                          cost: _serviceCost,
                          duration: _serviceDuration,
                          key: docData['key'],
                          ctx: context,
                        );
                      },
                      child: const Text('Update Service'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitServiceForm({
    required String name,
    required String type,
    required int cost,
    required int duration,
    required BuildContext ctx,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userData?.uid)
          .collection('servicesList')
          .doc()
          .set(
        {
          'serviceName': name,
          'serviceType': type,
          'serviceCost': cost,
          'serviceDuration': duration,
          'dateAdded': DateTime.now(),
          'key': DateTime.now().toString(),
        },
      );
    } on FirebaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
    Navigator.of(ctx).pop();
  }

  void _editServiceForm({
    required String name,
    required String type,
    required int cost,
    required int duration,
    required String key,
    required BuildContext ctx,
  }) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userData?.uid)
          .collection('servicesList');
      final querySnapshot = await collectionRef.get();
      final documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data();
        if (data['key'] == key) {
          collectionRef.doc(document.id).update(
            {
              'serviceName': name,
              'serviceType': type,
              'serviceCost': cost,
              'serviceDuration': duration,
            },
          );
        }
      }
    } on FirebaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
    Navigator.of(ctx).pop();
  }

  void _deleteService(String key, BuildContext ctx) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userData?.uid)
          .collection('servicesList');
      final querySnapshot = await collectionRef.get();
      final documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data();
        if (data['key'] == key && confirmed != null && confirmed) {
          collectionRef.doc(document.id).delete();
        }
      }
    } on FirebaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FutureBuilder(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('serviceProviders')
                    .doc(futureSnapshot.data?.uid)
                    .collection('servicesList')
                    .orderBy(
                      'dateAdded',
                      descending: true,
                    )
                    .snapshots(),
                builder: (ctx, servicesSnapshot) {
                  if (servicesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (servicesSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No services added yet'),
                    );
                  }
                  final servicesDocs = servicesSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: servicesDocs.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: ListTile(
                          key: ValueKey(servicesDocs[index]),
                          title: Text(
                            servicesDocs[index]['serviceName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          // isThreeLine: true,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                servicesDocs[index]['serviceType'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Service Cost: ${servicesDocs[index]['serviceCost']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Service Duration: ${servicesDocs[index]['serviceDuration']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _editService(
                                    context, servicesDocs[index].data()),
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              IconButton(
                                onPressed: () => _deleteService(
                                  servicesDocs[index]['key'],
                                  context,
                                ),
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).colorScheme.error,
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
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            elevation: 0,
          ),
          onPressed: () => _addNewService(context),
          child: const Text('Add New Service'),
        ),
      ],
    );
  }
}
