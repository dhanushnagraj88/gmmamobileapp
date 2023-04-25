import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_profile_complete_screen.dart';

import '../../widgets/service_provider/service_provider_auth_form.dart';

class ServiceProviderAuthScreen extends StatefulWidget {
  const ServiceProviderAuthScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-auth-screen';

  @override
  State<ServiceProviderAuthScreen> createState() =>
      _ServiceProviderAuthScreenState();
}

class _ServiceProviderAuthScreenState extends State<ServiceProviderAuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitAuthForm({
    required int phone,
    required String email,
    required String password,
    required bool isLogin,
    required BuildContext ctx,
  }) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('serviceProviders')
            .doc(authResult.user!.uid)
            .set({
          'email': email,
          'phone': phone,
        });
        Navigator.of(context).pushReplacementNamed(
            ServiceProviderProfileCompleteScreen.routeName);
      }
    } on FirebaseException catch (error) {
      String message = 'An error occured, please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ServiceProviderAuthForm(
        isLoading: _isLoading,
        submitFn: _submitAuthForm,
      ),
    );
  }
}
