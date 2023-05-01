import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomerQRScreen extends StatefulWidget {
  const CustomerQRScreen({Key? key}) : super(key: key);

  @override
  State<CustomerQRScreen> createState() => _CustomerQRScreenState();
}

class _CustomerQRScreenState extends State<CustomerQRScreen> {
  String? userID;

  DocumentSnapshot<Map<String, dynamic>>? _currentUserData;

  void _getCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final userData = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user!.uid)
          .get();
      setState(() {
        _currentUserData = userData;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    userID = FirebaseAuth.instance.currentUser?.uid;
    _getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _currentUserData != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImage(data: userID!, size: 300),
                Text(
                  'Customer Name: ${_currentUserData!['userName']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Customer Number: ${_currentUserData!['phone']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
