import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderInventoryList extends StatefulWidget {
  const ServiceProviderInventoryList({Key? key}) : super(key: key);

  @override
  State<ServiceProviderInventoryList> createState() =>
      _ServiceProviderInventoryListState();
}

class _ServiceProviderInventoryListState
    extends State<ServiceProviderInventoryList> {
  final _formKey = GlobalKey<FormState>();
  User? userData;
  DocumentSnapshot<Map<String, dynamic>>? collectionsData;

  List<dynamic>? garageTypes = [];
  var _partName = '';
  var _partType = '';
  var _partCost = 0;
  var _partInstallDuration = 0;
  var _partQuantity = 0;

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

  void _addNewPart(BuildContext context) {
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
                      key: const ValueKey('partName'),
                      decoration: const InputDecoration(labelText: 'Part Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _partName = value!;
                      },
                    ),
                    DropdownButtonFormField(
                      key: const ValueKey('partType'),
                      items: garageTypes
                          ?.map(
                            (val) => DropdownMenuItem(
                              key: ValueKey(val),
                              value: val,
                              child: Text(val),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Choose Part Type',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _partType = value as String;
                      },
                      onChanged: (newValue) => setState(() {
                        _partType = newValue as String;
                      }),
                    ),
                    TextFormField(
                      key: const ValueKey('partQuantity'),
                      decoration: const InputDecoration(
                        labelText: 'Part Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partQuantity = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('partCost'),
                      decoration: const InputDecoration(
                        labelText: 'Part Cost',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partCost = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('partInstallDuration'),
                      decoration: const InputDecoration(
                        labelText: 'Part Installation Duration in Hours',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partInstallDuration = int.parse(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _submitPartForm(
                          name: _partName,
                          type: _partType,
                          quantity: _partQuantity,
                          cost: _partCost,
                          duration: _partInstallDuration,
                          ctx: context,
                        );
                      },
                      child: const Text('Add Part'),
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

  void _editPart(BuildContext context, Map<String, dynamic> docData) async {
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
                      initialValue: docData['partName'],
                      key: const ValueKey('partName'),
                      decoration: const InputDecoration(labelText: 'Part Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _partName = value!;
                      },
                    ),
                    DropdownButtonFormField(
                      key: const ValueKey('partType'),
                      value: docData['partType'],
                      items: garageTypes
                          ?.map((val) => DropdownMenuItem(
                                key: ValueKey(val),
                                value: val,
                                child: Text(val),
                              ))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Choose Part Type',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _partType = value as String;
                      },
                      onChanged: (newValue) => setState(() {
                        _partType = newValue as String;
                      }),
                    ),
                    TextFormField(
                      key: const ValueKey('partQuantity'),
                      initialValue: docData['partQuantity'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Part Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partQuantity = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('partCost'),
                      initialValue: docData['partCost'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Part Cost',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partCost = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('partDuration'),
                      initialValue: docData['partDuration'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Part Installation Duration in Hours',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _partInstallDuration = int.parse(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _editPartForm(
                          name: _partName,
                          type: _partType,
                          quantity: _partQuantity,
                          cost: _partCost,
                          duration: _partInstallDuration,
                          key: docData['key'],
                          ctx: context,
                        );
                      },
                      child: const Text('Update Part'),
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

  void _submitPartForm({
    required String name,
    required String type,
    required int quantity,
    required int cost,
    required int duration,
    required BuildContext ctx,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userData?.uid)
          .collection('inventoryList')
          .doc()
          .set(
        {
          'partName': name,
          'partType': type,
          'partQuantity': quantity,
          'partCost': cost,
          'partDuration': duration,
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

  void _editPartForm({
    required String name,
    required String type,
    required int quantity,
    required int cost,
    required int duration,
    required String key,
    required BuildContext ctx,
  }) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userData?.uid)
          .collection('inventoryList');
      final querySnapshot = await collectionRef.get();
      final documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data();
        if (data['key'] == key) {
          collectionRef.doc(document.id).update(
            {
              'partName': name,
              'partType': type,
              'partQuantity': quantity,
              'partCost': cost,
              'partDuration': duration,
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

  void _deletePart(String key, BuildContext ctx) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Part'),
        content: const Text('Are you sure you want to delete this part?'),
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
          .collection('inventoryList');
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
                    .collection('inventoryList')
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
                      child: Text('No Parts added yet'),
                    );
                  }
                  final servicesDocs = servicesSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: servicesDocs.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: ListTile(
                          key: ValueKey(servicesDocs[index]),
                          leading: SizedBox(
                            height: double.infinity,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                servicesDocs[index]['partQuantity'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            servicesDocs[index]['partName'],
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
                                servicesDocs[index]['partType'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Part Cost: ${servicesDocs[index]['partCost']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Installation Duration: ${servicesDocs[index]['partDuration']}',
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
                                onPressed: () => _editPart(
                                    context, servicesDocs[index].data()),
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              IconButton(
                                onPressed: () => _deletePart(
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
          onPressed: () => _addNewPart(context),
          child: const Text('Add New Part'),
        ),
      ],
    );
  }
}
