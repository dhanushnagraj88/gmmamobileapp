import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                ServiceProviderServicesAndInventoryScreen.routeName,
              ),
              splashColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: 120,
                width: (size.width * 0.8) / 2,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: const Text(
                  'Services and Inventory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                ServiceProviderEstimationCalculatorScreen.routeName,
              ),
              splashColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: 120,
                width: (size.width * 0.8) / 2,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: const Text(
                  'Estimation Calculator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
