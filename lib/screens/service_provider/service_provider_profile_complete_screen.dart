import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './service_provider_tabs_screen.dart';
import '../../widgets/service_provider/service_provider_profile_complete_form.dart';

class ServiceProviderProfileCompleteScreen extends StatefulWidget {
  const ServiceProviderProfileCompleteScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-profile-complete-screen';

  @override
  State<ServiceProviderProfileCompleteScreen> createState() =>
      _ServiceProviderProfileCompleteScreenState();
}

class _ServiceProviderProfileCompleteScreenState
    extends State<ServiceProviderProfileCompleteScreen> {
  var _isLoading = false;
  void _submitProfileForm({
    required String ownerName,
    required String garageName,
    required String employeeType,
    String? garageEmployeesID,
    required List<String> garageTypes,
    required File garageImage,
    required LatLng garageLocation,
    required String garageAddress,
    required String upiID,
    required BuildContext ctx,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final ref =
          FirebaseStorage.instance.ref().child('service_provider_images').child(
                '${garageLocation.latitude}${garageLocation.longitude}jpg',
              );
      UploadTask uploadTask = ref.putFile(garageImage);
      uploadTask.whenComplete(() async {
        final userData = FirebaseAuth.instance.currentUser;
        final url = await ref.getDownloadURL();
        final fireData = FirebaseFirestore.instance
            .collection('serviceProviders')
            .doc(userData?.uid);
        fireData.update({
          'ownerName': ownerName,
          'garageName': garageName,
          'employeeType': employeeType,
          'garageEmployeesID': garageEmployeesID ?? '',
          'garageTypes': garageTypes,
          'imageUrl': url,
          'garageLocation':
              GeoPoint(garageLocation.latitude, garageLocation.longitude),
          'garageAddress': garageAddress,
          'upiId': upiID,
        });
      }).then((value) {
        if (value.state == TaskState.success) {
          Navigator.of(context)
              .pushReplacementNamed(ServiceProviderTabsScreen.routeName);
        }
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
      backgroundColor: Theme.of(context).primaryColor,
      body: ServiceProviderProfileCompleteForm(
        isLoading: _isLoading,
        submitFn: _submitProfileForm,
      ),
    );
  }
}
