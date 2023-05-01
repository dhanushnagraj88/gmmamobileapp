import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../widgets/customer/add_vehicle_form.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);

  static const routeName = '/add-vehicle-screen';

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  void _submitVehicleForm({
    required String ownerName,
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleMake,
    required String vehicleModel,
    required File vehicleImage,
    required BuildContext ctx,
  }) async {
    // UserCredential authResult;
    try {
      final userData = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child('customer_images')
          .child(userData!.uid)
          .child('${vehicleNumber}jpg');
      UploadTask uploadTask = ref.putFile(vehicleImage);
      uploadTask.whenComplete(() async {
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(userData.uid)
            .collection('vehiclesList')
            .doc(vehicleNumber)
            .set({
          'ownerName': ownerName,
          'vehicleNumber': vehicleNumber,
          'vehicleType': vehicleType,
          'vehicleMake': vehicleMake,
          'vehicleModel': vehicleModel,
          'imageUrl': url,
          'userID': userData.uid
        });
      });
    } on FirebaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Vehicle'),
      ),
      body: AddVehicleForm(submitFn: _submitVehicleForm),
    );
  }
}
