import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/customer/customer_home_screen.dart';
import 'package:gmma/screens/customer/customer_qr_screen.dart';
import 'package:gmma/screens/customer/customer_tabs_screen.dart';
import 'package:gmma/screens/employee/customer_payments_screen.dart';
import 'package:gmma/screens/employee/employee_login_screen.dart';
import 'package:gmma/screens/employee/employee_tabs_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_choose_parts_and_services_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_choose_vehicle_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_completed_jobs_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_estimation_calculator_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_home_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_manage_customers_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_manage_employee_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_ongoing_jobs_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_pending_jobs_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_profile_complete_screen.dart';
import 'package:gmma/screens/service_provider/service_provider_qr_scan_screen.dart';
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
        CustomerTabsScreen.routeName: (ctx) => const CustomerTabsScreen(),
        CustomerHomeScreen.routeName: (ctx) => const CustomerHomeScreen(),
        CustomerQRScreen.routeName: (ctx) => const CustomerQRScreen(),
        CustomerPaymentsScreen.routeName: (ctx) =>
            const CustomerPaymentsScreen(),
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
        ServiceProviderManageCustomersScreen.routeName: (ctx) =>
            const ServiceProviderManageCustomersScreen(),
        ServiceProviderQRScanScreen.routeName: (ctx) =>
            const ServiceProviderQRScanScreen(),
        ServiceProviderManageEmployeeScreen.routeName: (ctx) =>
            const ServiceProviderManageEmployeeScreen(),
        ServiceProviderChooseVehicleScreen.routeName: (ctx) =>
            const ServiceProviderChooseVehicleScreen(),
        ServiceProviderChoosePartsAndServicesScreen.routeName: (ctx) =>
            const ServiceProviderChoosePartsAndServicesScreen(),
        ServiceProviderPendingJobsScreen.routeName: (ctx) =>
            const ServiceProviderPendingJobsScreen(),
        ServiceProviderOngoingJobsScreen.routeName: (ctx) =>
            const ServiceProviderOngoingJobsScreen(),
        ServiceProviderCompletedJobsScreen.routeName: (ctx) =>
            const ServiceProviderCompletedJobsScreen(),
        EmployeeLoginScreen.routeName: (ctx) => const EmployeeLoginScreen(),
        EmployeeTabsScreen.routeName: (ctx) => const EmployeeTabsScreen(),
      },
    );
  }
}
