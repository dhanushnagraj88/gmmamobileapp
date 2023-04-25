import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_profile_complete_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_tabs_screen.dart';

import './service_provider_auth_screen.dart';

class ServiceProviderRoutingScreen extends StatelessWidget {
  const ServiceProviderRoutingScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-routing-screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (userSnapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('serviceProviders')
                    .doc(user!.uid)
                    .get(),
                builder: (ctx, userDataSnapshot) {
                  if (userDataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!userDataSnapshot.data!
                      .data()!
                      .containsKey('garageAddress')) {
                    return const ServiceProviderProfileCompleteScreen();
                  } else {
                    return const ServiceProviderTabsScreen();
                  }
                });
          }
          return const ServiceProviderAuthScreen();
        });
  }
}
