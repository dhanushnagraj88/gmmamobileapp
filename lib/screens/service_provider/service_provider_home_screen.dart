import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_manage_employee_screen.dart';

import './service_provider_estimation_calculator_screen.dart';
import './service_provider_manage_customers_screen.dart';
import './service_provider_services_and_inventory_screen.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  const ServiceProviderHomeScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-home-screen';

  @override
  State<ServiceProviderHomeScreen> createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  DocumentSnapshot<Map<String, dynamic>>? _currentUserData;

  void _getCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final userData = await FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(user!.uid)
          .get();
      setState(() {
        _currentUserData = userData;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: const Icon(
              Icons.group,
              color: Colors.black,
            ),
            title: const Text(
              'Manage Customers',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            tileColor: Theme.of(context).primaryColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () => Navigator.of(context).pushNamed(
              ServiceProviderManageCustomersScreen.routeName,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: const Icon(
              Icons.inventory,
              color: Colors.black,
            ),
            title: const Text(
              'Services and Inventory',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            tileColor: Theme.of(context).primaryColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () => Navigator.of(context).pushNamed(
              ServiceProviderServicesAndInventoryScreen.routeName,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: const Icon(
              Icons.calculate,
              color: Colors.black,
            ),
            title: const Text(
              'Estimation Calculator',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            tileColor: Theme.of(context).primaryColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () => Navigator.of(context).pushNamed(
              ServiceProviderEstimationCalculatorScreen.routeName,
            ),
          ),
        ),
        if (_currentUserData?['employeeType'] == 'Multiple Employee')
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(
                Icons.engineering,
                color: Colors.black,
              ),
              title: const Text(
                'Manage Employees',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tileColor: Theme.of(context).primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () => Navigator.of(context).pushNamed(
                ServiceProviderManageEmployeeScreen.routeName,
              ),
            ),
          ),
      ],
    );
  }
}
