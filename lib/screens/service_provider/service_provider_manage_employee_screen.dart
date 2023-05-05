import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderManageEmployeeScreen extends StatefulWidget {
  const ServiceProviderManageEmployeeScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-manage-employees-screen';

  @override
  State<ServiceProviderManageEmployeeScreen> createState() =>
      _ServiceProviderManageEmployeeScreenState();
}

class _ServiceProviderManageEmployeeScreenState
    extends State<ServiceProviderManageEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  User? userData;
  DocumentSnapshot<Map<String, dynamic>>? collectionsData;

  var _employeeName = '';
  var _employeeIDNumber = '';
  var _employeeDesignation = '';
  var _employeePassword = '';

  Future<void> _getCurrentUserData() async {
    userData = FirebaseAuth.instance.currentUser;
    final collectionData = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .get();
    setState(() {
      collectionsData = collectionData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserData();
    super.initState();
  }

  void _addNewEmployee(BuildContext context) {
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
                      key: const ValueKey('employeeName'),
                      decoration:
                          const InputDecoration(labelText: 'Employee Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeeName = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('employeeIDNumber'),
                      decoration: const InputDecoration(
                          labelText: 'Employee ID Number'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _employeeIDNumber = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('employeeDesignation'),
                      decoration: const InputDecoration(
                          labelText: 'Employee Designation'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeeDesignation = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('employeePassword'),
                      decoration:
                          const InputDecoration(labelText: 'Employee Password'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeePassword = value!;
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _submitEmployeeForm(
                          name: _employeeName,
                          idNumber: _employeeIDNumber,
                          designation: _employeeDesignation,
                          password: _employeePassword,
                          ctx: context,
                        );
                      },
                      label: const Text('Add Employee'),
                      icon: const Icon(Icons.person_add),
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

  void _submitEmployeeForm({
    required String name,
    required String idNumber,
    required String designation,
    required String password,
    required BuildContext ctx,
  }) async {
    final auth = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(auth?.uid)
        .collection('employeesList')
        .doc(idNumber)
        .set({
      'employeeName': name,
      'employeeIDNumber': idNumber,
      'employeeDesignation': designation,
      'employeeUsername':
          '$idNumber@${collectionsData!['garageEmployeesID']}.com',
      'employeePassword': password,
      'userID': auth!.uid,
      'dateAdded': DateTime.now(),
      'key': DateTime.now().toString(),
      'garageEmployeesID': collectionsData!['garageEmployeesID'],
    });
    Navigator.of(ctx).pop();
  }

  void _editEmployee(BuildContext context, Map<String, dynamic> docData) {
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
                      initialValue: docData['employeeName'],
                      key: const ValueKey('employeeName'),
                      decoration:
                          const InputDecoration(labelText: 'Employee Name'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeeName = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: docData['employeeIDNumber'],
                      key: const ValueKey('employeeIDNumber'),
                      decoration: const InputDecoration(
                          labelText: 'Employee ID Number'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _employeeIDNumber = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: docData['employeeDesignation'],
                      key: const ValueKey('employeeDesignation'),
                      decoration: const InputDecoration(
                          labelText: 'Employee Designation'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeeDesignation = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: docData['employeePassword'],
                      key: const ValueKey('employeePassword'),
                      decoration:
                          const InputDecoration(labelText: 'Employee Password'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _employeePassword = value!;
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _editEmployeeForm(
                          name: _employeeName,
                          idNumber: _employeeIDNumber,
                          designation: _employeeDesignation,
                          password: _employeePassword,
                          key: docData['key'],
                          ctx: context,
                        );
                      },
                      label: const Text('Update Employee'),
                      icon: const Icon(Icons.person_add),
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

  void _editEmployeeForm({
    required String name,
    required String idNumber,
    required String designation,
    required String password,
    required String key,
    required BuildContext ctx,
  }) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .collection('employeesList');
    final querySnapshot = await collectionRef.get();
    final documents = querySnapshot.docs;
    for (final document in documents) {
      final data = document.data();
      if (data['key'] == key) {
        collectionRef.doc(document.id).update({
          'employeeName': name,
          'employeeIDNumber': idNumber,
          'employeeDesignation': designation,
          'employeePassword': password,
        });
      }
    }
    Navigator.of(ctx).pop();
  }

  void _deleteEmployee(String key, BuildContext ctx) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Employee'),
        content: const Text('Are you sure you want to remove this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    final collectionRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .collection('employeesList');
    final querySnapshot = await collectionRef.get();
    final documents = querySnapshot.docs;
    for (final document in documents) {
      final data = document.data();
      if (data['key'] == key && confirmed != null && confirmed) {
        collectionRef.doc(document.id).delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Employees'),
      ),
      body: FutureBuilder(
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
                .collection('employeesList')
                .orderBy('dateAdded')
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
                  child: Text('No employees added yet'),
                );
              }
              final employeesDocs = employeesSnapshot.data!.docs;
              return ListView.builder(
                itemCount: employeesDocs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      key: ValueKey(employeesDocs[index]),
                      leading: CircleAvatar(
                        child: Text(
                          employeesDocs[index]['employeeIDNumber'],
                        ),
                      ),
                      title: Text(
                        employeesDocs[index]['employeeName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      // isThreeLine: true,
                      subtitle: Text(
                        employeesDocs[index]['employeeDesignation'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editEmployee(
                              context,
                              employeesDocs[index].data(),
                            ),
                            icon: const Icon(
                              Icons.edit,
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                          IconButton(
                            onPressed: () => _deleteEmployee(
                              employeesDocs[index]['key'],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addNewEmployee(context),
        label: const Text('Add Employee'),
        icon: const Icon(Icons.person_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
