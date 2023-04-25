import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_routing%20_screen.dart';

import './customer/customer_routing_screen.dart';

class ChooseLoginTypeScreen extends StatelessWidget {
  const ChooseLoginTypeScreen({Key? key}) : super(key: key);

  static const routeName = '/choose-login-type-screen';

  Widget elevButton(String routeName, String label, BuildContext ctx) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => Navigator.of(ctx).pushReplacementNamed(routeName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Login Type'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              elevButton(
                CustomerRoutingScreen.routeName,
                'I am a Customer',
                context,
              ),
              elevButton(
                ServiceProviderRoutingScreen.routeName,
                'I am a Service Provider',
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
