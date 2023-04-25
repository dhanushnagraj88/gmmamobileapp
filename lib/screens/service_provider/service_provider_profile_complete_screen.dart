import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gmma/screens/service_provider/service_provider_tabs_screen.dart';
import 'package:gmma/widgets/service_provider/service_provider_profile_omplete_form.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    required String employeeType,
    required List<String> garageTypes,
    required File garageImage,
    required LatLng garageLocation,
    required String garageAddress,
    required BuildContext ctx,
  }) async {
    UserCredential authResult;
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
          'employeeType': employeeType,
          'garageTypes': garageTypes,
          'imageUrl': url,
          'garageLocation':
              GeoPoint(garageLocation.latitude, garageLocation.longitude),
          'garageAddress': garageAddress,
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
          isLoading: _isLoading, submitFn: _submitProfileForm),
    );
  }
}
