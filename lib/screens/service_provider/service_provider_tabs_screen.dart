import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './service_provider_home_screen.dart';
import './service_provider_payments_screen.dart';
import './service_provider_routing%20_screen.dart';
import './service_provider_transactions_screen.dart';

class ServiceProviderTabsScreen extends StatefulWidget {
  const ServiceProviderTabsScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-tabs-screen';

  @override
  State<ServiceProviderTabsScreen> createState() =>
      _ServiceProviderTabsScreenState();
}

class _ServiceProviderTabsScreenState extends State<ServiceProviderTabsScreen> {
  List<Map<String, dynamic>>? _pages;

  int _selectedPageIndex = 0;

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

  void _selectPageIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserDetails();

    _pages = [
      {
        'page': const ServiceProviderHomeScreen(),
        'title': 'Dashboard',
      },
      {
        'page': const ServiceProviderTransactionsScreen(),
        'title': 'Transactions History',
      },
      {
        'page': const ServiceProviderPaymentsScreen(),
        'title': 'Pending Payments',
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages![_selectedPageIndex]['title']),
        actions: [
          if (_selectedPageIndex == 0)
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed(
                  ServiceProviderRoutingScreen.routeName,
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
              icon: const Icon(Icons.home),
              label: 'Home',
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              label: 'Transactions',
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code_scanner),
              label: 'Payments',
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ]),
    );
  }
}
