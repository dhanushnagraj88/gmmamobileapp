import 'package:flutter/material.dart';

import './customer/customer_routing_screen.dart';
import './employee/employee_login_screen.dart';
import './service_provider/service_provider_routing%20_screen.dart';

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

  Future<void> _showSimpleDialog(BuildContext ctx) async {
    await showDialog<void>(
      context: ctx,
      builder: (BuildContext ctx) {
        return SimpleDialog(
          alignment: Alignment.center,
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {},
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx)
                    .pushNamed(ServiceProviderRoutingScreen.routeName),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    'Login as Owner',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {},
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx)
                    .pushReplacementNamed(EmployeeLoginScreen.routeName),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    'Login as Employee',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
              ElevatedButton(
                onPressed: () => _showSimpleDialog(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    'I am a Service Provider',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
