import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/customer/customer_auth_form.dart';

class CustomerAuthScreen extends StatefulWidget {
  const CustomerAuthScreen({Key? key}) : super(key: key);

  static const routeName = '/customer-auth-screen';

  @override
  State<CustomerAuthScreen> createState() => _CustomerAuthScreenState();
}

class _CustomerAuthScreenState extends State<CustomerAuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm({
    required String userName,
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
        print(authResult);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'phone': phone,
          'userID': authResult.user!.uid,
        });
      }
    } on FirebaseException catch (error) {
      String message = 'An error occured, please check your credentials';
      if (error.message != null) {
        message = error.message!;
        print('The error is: $message');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

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
      body: CustomerAuthForm(isLoading: _isLoading, submitFn: _submitAuthForm),
    );
  }
}
