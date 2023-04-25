import 'package:flutter/material.dart';

class ServiceProviderEstimationCalculatorScreen extends StatefulWidget {
  const ServiceProviderEstimationCalculatorScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-estimation-calculator-screen';

  @override
  State<ServiceProviderEstimationCalculatorScreen> createState() =>
      _ServiceProviderEstimationCalculatorScreenState();
}

class _ServiceProviderEstimationCalculatorScreenState
    extends State<ServiceProviderEstimationCalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Estimate'),
      ),
      body: const Center(
        child: Text('Create an Estimate'),
      ),
    );
  }
}
