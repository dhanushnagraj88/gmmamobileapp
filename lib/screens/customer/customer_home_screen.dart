import 'package:flutter/material.dart';

import '../../widgets/customer/vehicles.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);
  static const routeName = '/customer-home-screen';
  @override
  Widget build(BuildContext context) {
    return const Vehicles();
  }
}
