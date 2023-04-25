import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/customer/customer_home_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_estimation_calculator_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_home_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_profile_complete_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_routing%20_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_services_and_inventory_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_tabs_screen.dart';

import './firebase_options.dart';
import './screens/choose_login_type_screen.dart';
import './screens/customer/add_vehicle_screen.dart';
import './screens/customer/customer_auth_screen.dart';
import './screens/customer/customer_routing_screen.dart';
import './screens/service_provider/service_provider_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMMA',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
      ),
      home: const ChooseLoginTypeScreen(),
      routes: {
        ChooseLoginTypeScreen.routeName: (ctx) => const ChooseLoginTypeScreen(),
        CustomerRoutingScreen.routeName: (ctx) => const CustomerRoutingScreen(),
        CustomerAuthScreen.routeName: (ctx) => const CustomerAuthScreen(),
        CustomerHomeScreen.routeName: (ctx) => const CustomerHomeScreen(),
        AddVehicleScreen.routeName: (ctx) => const AddVehicleScreen(),
        ServiceProviderTabsScreen.routeName: (ctx) =>
            const ServiceProviderTabsScreen(),
        ServiceProviderRoutingScreen.routeName: (ctx) =>
            const ServiceProviderRoutingScreen(),
        ServiceProviderAuthScreen.routeName: (ctx) =>
            const ServiceProviderAuthScreen(),
        ServiceProviderHomeScreen.routeName: (ctx) =>
            const ServiceProviderHomeScreen(),
        ServiceProviderProfileCompleteScreen.routeName: (ctx) =>
            const ServiceProviderProfileCompleteScreen(),
        ServiceProviderServicesAndInventoryScreen.routeName: (ctx) =>
            const ServiceProviderServicesAndInventoryScreen(),
        ServiceProviderEstimationCalculatorScreen.routeName: (ctx) =>
            const ServiceProviderEstimationCalculatorScreen(),
      },
    );
  }
}
