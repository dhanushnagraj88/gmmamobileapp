import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './employee_tabs_screen.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({Key? key}) : super(key: key);

  static const routeName = '/employee-login-screen';

  @override
  State<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _garageEmployeeID = '';
  var _userName = '';
  var _employeeIDNumber = '';
  var _userPassword = '';
  var _spEmployeeID = '';

  QuerySnapshot<Map<String, dynamic>>? _employeeCollection;
  QuerySnapshot<Map<String, dynamic>>? _serviceProvidersData;
  void _getServiceProvidersData(BuildContext ctx) {
    _formKey.currentState?.save();
    FirebaseFirestore.instance
        .collection('serviceProviders')
        .where('garageEmployeesID', isEqualTo: _garageEmployeeID)
        .get()
        .then((value) {
      setState(() {
        print(value.docs.first.data());
        _serviceProvidersData = value;
        var docRef = _serviceProvidersData?.docs.first.reference;
        docRef
            ?.collection('employeesList')
            .where('employeeUsername', isEqualTo: _userName)
            .get()
            .then((value) => _employeeCollection = value);
        _spEmployeeID =
            _serviceProvidersData?.docs.first.data()['garageEmployeesID'];
        print(_serviceProvidersData?.docs.first.data()['garageEmployeesID']);
        print(_employeeCollection?.docs.first.data());
      });
    });
  }

  void _tryLogin() {
    final isValid = _formKey.currentState?.validate();
    if (isValid!) {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pushReplacementNamed(
        EmployeeTabsScreen.routeName,
        arguments: [
          _spEmployeeID,
          _employeeIDNumber,
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey('garageEmployeeID'),
                      decoration: const InputDecoration(
                        labelText: 'Garage Employee ID',
                      ),
                      validator: (value) {
                        if (value != _spEmployeeID) {
                          return 'Enter a valid Employee ID';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _garageEmployeeID = value!;
                      },
                      onFieldSubmitted: (_) =>
                          _getServiceProvidersData(context),
                    ),
                    TextFormField(
                      key: const ValueKey('employeeIDNumber'),
                      decoration: const InputDecoration(
                        labelText: 'Employee ID Number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value !=
                            _employeeCollection?.docs.first
                                .data()['employeeIDNumber']) {
                          return 'Enter a valid Employee ID Number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _employeeIDNumber = value!;
                      },
                      onFieldSubmitted: (_) =>
                          _getServiceProvidersData(context),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('userName'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value !=
                            _employeeCollection?.docs.first
                                .data()['employeeUsername']) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      onFieldSubmitted: (_) =>
                          _getServiceProvidersData(context),
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value !=
                            _employeeCollection?.docs.first
                                .data()['employeePassword']) {
                          return ' Incorrect Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                      onFieldSubmitted: (_) =>
                          _getServiceProvidersData(context),
                    ),
                    ElevatedButton(
                      onPressed: () => _tryLogin(),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
