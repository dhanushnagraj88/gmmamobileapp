import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_choose_vehicle_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_completed_jobs_list.dart';
import 'package:gmma/screens/service_provider/service_provider_manage_employee_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_ongoing_jobs_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_pending_jobs_screen.dart';

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
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? _pendingJobs;
  QuerySnapshot<Map<String, dynamic>>? _ongoingJobs;
  QuerySnapshot<Map<String, dynamic>>? _completedJobs;
  void _getCurrentUserDetails() async {
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

  void _getJobsData() async {
    final pendingJobs = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user?.uid)
        .collection('pendingJobsList')
        .get();
    setState(() {
      _pendingJobs = pendingJobs;
    });
    final ongoingJobs = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user?.uid)
        .collection('ongoingJobsList')
        .get();
    setState(() {
      _ongoingJobs = ongoingJobs;
    });
    final completedJobs = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user?.uid)
        .collection('completedJobsList')
        .get();
    setState(() {
      _completedJobs = completedJobs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserDetails();
    _getJobsData();
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
          color: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed(
                    ServiceProviderCompletedJobsScreen.routeName,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      _completedJobs?.docs.length != null
                          ? _completedJobs!.docs.length.toString()
                          : '0',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    'Completed Jobs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_circle_right,
                      color: Theme.of(context).primaryColorLight,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed(
                    ServiceProviderOngoingJobsScreen.routeName,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      _ongoingJobs?.docs.length != null
                          ? _ongoingJobs!.docs.length.toString()
                          : '0',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    'Ongoing Jobs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_circle_right,
                      color: Theme.of(context).primaryColorLight,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed(
                    ServiceProviderPendingJobsScreen.routeName,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      _pendingJobs?.docs.length != null
                          ? _pendingJobs!.docs.length.toString()
                          : '0',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    'Pending Jobs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_circle_right,
                    color: Theme.of(context).primaryColorLight,
                    size: 35,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(ServiceProviderChooseVehicleScreen.routeName),
                  icon: const Icon(
                    Icons.add_task,
                    size: 35,
                  ),
                  label: Text(
                    'Add Job Card',
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
