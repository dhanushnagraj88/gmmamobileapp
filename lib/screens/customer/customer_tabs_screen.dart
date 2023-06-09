import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './add_vehicle_screen.dart';
import './customer_home_screen.dart';
import './customer_nearby_garages.dart';
import './customer_pending_payments_screen.dart';
import './customer_qr_screen.dart';
import './customer_routing_screen.dart';

class CustomerTabsScreen extends StatefulWidget {
  const CustomerTabsScreen({Key? key}) : super(key: key);

  static const routeName = '/customer-tabs-screen';

  @override
  State<CustomerTabsScreen> createState() => _CustomerTabsScreenState();
}

class _CustomerTabsScreenState extends State<CustomerTabsScreen> {
  List<Map<String, dynamic>>? _pages;

  int _selectedPageIndex = 0;

  DocumentSnapshot<Map<String, dynamic>>? _currentUserData;

  void _getCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final userData = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user!.uid)
          .get();
      setState(() {
        _currentUserData = userData;
        _pages = [
          {
            'page': const CustomerHomeScreen(),
            'title': _currentUserData?['userName'] != null
                ? 'Welcome, ${_currentUserData?['userName']}'
                : 'Welcome',
          },
          {
            'page': const CustomerNearbyGarages(),
            'title': 'Nearby Available Garages',
          },
          {
            'page': const CustomerPendingPaymentsScreen(),
            'title': 'Pending Payments',
          },
        ];
      });
    } catch (error) {
      print(error);
    }
  }

  void _selectPageIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(_pages![_selectedPageIndex]['title']),
              actions: [
                if (_selectedPageIndex == 0)
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      CustomerQRScreen.routeName,
                    ),
                    icon: const Icon(Icons.qr_code_2),
                  ),
                if (_selectedPageIndex == 0)
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed(
                        CustomerRoutingScreen.routeName,
                      );
                    },
                    icon: const Icon(Icons.logout),
                  )
              ],
            ),
            body: _pages![_selectedPageIndex]['page'],
            bottomNavigationBar: BottomNavigationBar(
              onTap: _selectPageIndex,
              backgroundColor: Theme.of(context).primaryColorLight,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.black,
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.directions_car),
                  label: 'Manage Vehicles',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.near_me),
                  label: 'Nearby Garages',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.payments_outlined),
                  label: 'Pending Payments',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            floatingActionButton: _selectedPageIndex == 0
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddVehicleScreen.routeName);
                    },
                    label: const Text('Add Vehicle'),
                    icon: const Icon(Icons.add),
                  )
                : null,
          );
  }
}
