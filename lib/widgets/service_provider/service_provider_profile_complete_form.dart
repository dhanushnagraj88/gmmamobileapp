import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmma/helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiselect/multiselect.dart';

import '../user_image_picker.dart';
import '../user_location_picker.dart';

class ServiceProviderProfileCompleteForm extends StatefulWidget {
  const ServiceProviderProfileCompleteForm({
    Key? key,
    required this.isLoading,
    required this.submitFn,
  }) : super(key: key);

  final bool isLoading;
  final void Function({
    required String ownerName,
    required String garageName,
    required String employeeType,
    String? garageEmployeesID,
    required List<String> garageTypes,
    required File garageImage,
    required LatLng garageLocation,
    required String garageAddress,
    required BuildContext ctx,
    required String upiID,
  }) submitFn;

  @override
  State<ServiceProviderProfileCompleteForm> createState() =>
      _ServiceProviderProfileCompleteFormState();
}

class _ServiceProviderProfileCompleteFormState
    extends State<ServiceProviderProfileCompleteForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeTypesList = [
    'Single-Owner/Employee',
    'Multiple Employee',
  ];
  final _garageTypes = [
    'Body Wash',
    'Two-Wheeler',
    'Three-Wheeler',
    'Four-Wheeler',
    'Heavy Vehicles',
  ];
  List<String>? _selectedGarageTypes = [];
  var _ownerName = '';
  var _garageName = '';
  var _garageEmployeesID = '';
  var _employeeType = '';
  var _upiID = '';
  File? _userImageFile;
  LatLng? _pickedLocation;
  String? _pickedAddress;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _selectedPlace(double lat, double long) async {
    _pickedLocation = LatLng(lat, long);
    _pickedAddress = await LocationHelper.getPlaceAddress(lat, long);
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        ctx: context,
        ownerName: _ownerName,
        garageName: _garageName,
        employeeType: _employeeType,
        garageEmployeesID: _garageEmployeesID,
        garageTypes: _selectedGarageTypes!,
        garageImage: _userImageFile!,
        garageLocation: _pickedLocation!,
        garageAddress: _pickedAddress!,
        upiID: _upiID,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey('ownerName'),
                    decoration: const InputDecoration(labelText: 'Owner Name'),
                    onSaved: (value) {
                      _ownerName = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the name of the owner';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('garageName'),
                    decoration: const InputDecoration(labelText: 'Garage Name'),
                    onSaved: (value) {
                      _garageName = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the name of the Garage';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        labelText: 'Select Employee Type'),
                    items: _employeeTypesList
                        .map(
                          (employeeType) => DropdownMenuItem(
                            value: employeeType,
                            child: Text(employeeType),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(
                      () {
                        _employeeType = value!;
                      },
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please choose the garage employment type';
                      }
                      return null;
                    },
                  ),
                  if (_employeeType == 'Multiple Employee')
                    TextFormField(
                      key: const ValueKey('garageEmployeesID'),
                      decoration: const InputDecoration(
                          labelText: 'Garage Employees ID'),
                      onSaved: (value) {
                        _garageEmployeesID = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Please enter a Garage Employees ID to manage employees';
                        }
                        return null;
                      },
                    ),
                  DropDownMultiSelect(
                    key: const ValueKey('garageType'),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please select at least one of the garage types';
                    //   }
                    //   return '';
                    // },
                    options: _garageTypes,
                    selectedValues: _selectedGarageTypes!,
                    onChanged: (value) => setState(
                      () {
                        _selectedGarageTypes = value;
                      },
                    ),
                    whenEmpty: 'Select your Garage Type',
                  ),
                  TextFormField(
                    key: const ValueKey('upiID'),
                    decoration: const InputDecoration(labelText: 'UPI ID'),
                    onSaved: (value) {
                      _upiID = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid UPI ID';
                      }
                      return null;
                    },
                  ),
                  UserImagePicker(imagePicker: _pickedImage),
                  UserLocationPicker(onSelectPlace: _selectedPlace),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: const Text('Complete Profile'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
