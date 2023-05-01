import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/customer/customer_tabs_screen.dart';

import './customer_auth_screen.dart';

class CustomerRoutingScreen extends StatelessWidget {
  const CustomerRoutingScreen({Key? key}) : super(key: key);

  static const routeName = '/customer-routing-screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return const CustomerTabsScreen();
          }
          return const CustomerAuthScreen();
        });
  }
}
