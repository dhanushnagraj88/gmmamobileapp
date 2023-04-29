import 'package:flutter/material.dart';
import 'package:gmma/widgets/service_provider/service_provider_inventory_list.dart';
import 'package:gmma/widgets/service_provider/service_provider_services_list.dart';

class ServiceProviderServicesAndInventoryScreen extends StatefulWidget {
  const ServiceProviderServicesAndInventoryScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-services-and-inventory-screen';

  @override
  State<ServiceProviderServicesAndInventoryScreen> createState() =>
      _ServiceProviderServicesAndInventoryScreenState();
}

class _ServiceProviderServicesAndInventoryScreenState
    extends State<ServiceProviderServicesAndInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Services and Inventory'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.design_services),
                text: 'Services',
              ),
              Tab(
                icon: Icon(Icons.inventory),
                text: 'Inventory',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ServiceProviderServicesList(),
            ServiceProviderInventoryList(),
          ],
        ),
      ),
    );
  }
}
