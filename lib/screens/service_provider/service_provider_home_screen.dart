import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_manage_customers_screen.dart';

import './service_provider_estimation_calculator_screen.dart';
import './service_provider_services_and_inventory_screen.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  const ServiceProviderHomeScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-home-screen';

  @override
  State<ServiceProviderHomeScreen> createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
      ],
    );
  }
}
