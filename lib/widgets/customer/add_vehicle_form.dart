import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './image_picker.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({Key? key, required this.submitFn}) : super(key: key);

  final void Function({
    required String ownerName,
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleMake,
    required String vehicleModel,
    required File vehicleImage,
    required BuildContext ctx,
  }) submitFn;
  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  File? _vehicleImageFile;
  final _formKey = GlobalKey<FormState>();

  var _ownerName = '';
  var _vehicleNumber = '';
  String? _vehicleType;
  String? _vehicleMake;
  String? _vehicleModel = '';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  final modelKey = GlobalKey<FormState>();
  void _pickedImage(File image) {
    _vehicleImageFile = image;
  }

  void _trySubmit() {
    _formKey.currentState!.save();
    widget.submitFn(
      ownerName: _ownerName,
      vehicleNumber: _vehicleNumber,
      vehicleType: _vehicleType!,
      vehicleMake: _vehicleMake!,
      vehicleModel: _vehicleModel!,
      vehicleImage: _vehicleImageFile!,
      ctx: context,
    );
  }

  Future<List<String>> _getVehiclesTypeList() async {
    List<String> vehiclesTypeList = [];
    await _database
        .collection('vehiclesList')
        .doc('typesOfVehicles')
        .get()
        .then(
      (value) {
        List<dynamic> dynamicList = value.data()!['vehicleTypes'];
        vehiclesTypeList =
            dynamicList.map((element) => element.toString()).toList();
      },
    );
    return vehiclesTypeList;
  }

  Future<List<String>> _getVehiclesMakeList(String vehicleType) async {
    List<String> vehicleMakeList = [];
    await _database
        .collection('vehiclesList')
        .doc('typesOfVehicles')
        .collection('vehiclesMakeList')
        .doc('vehiclesMakeList')
        .get()
        .then(
      (value) {
        List<dynamic> dynamicList = value.data()![vehicleType];
        vehicleMakeList =
            dynamicList.map((element) => element.toString()).toList();
      },
    );
    return vehicleMakeList;
  }

  Future<List<String>> _getVehicleModelsList(
      String vehicleType, String vehicleMake) async {
    List<String> vehicleModelsList = [];
    await _database
        .collection('vehiclesList')
        .doc('typesOfVehicles')
        .collection('vehiclesMakeList')
        .doc('vehiclesMakeList')
        .collection('vehiclesModelList')
        .doc(vehicleType)
        .get()
        .then(
      (value) {
        List<dynamic> dynamicList = value.data()![vehicleMake];
        vehicleModelsList =
            dynamicList.map((element) => element.toString()).toList();
      },
    );
    return vehicleModelsList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey('name'),
                  decoration: const InputDecoration(labelText: 'Owner Name'),
                  textCapitalization: TextCapitalization.words,
                  onSaved: (value) {
                    _ownerName = value!;
                  },
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  key: const ValueKey('number'),
                  decoration:
                      const InputDecoration(labelText: 'Vehicle Number'),
                  onSaved: (value) {
                    _vehicleNumber = value!;
                  },
                ),
                FutureBuilder(
                  future: _getVehiclesTypeList(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField(
                      key: const ValueKey('vehicleType'),
                      onSaved: (value) {
                        _vehicleType = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Choose Vehicle Type',
                      ),
                      items: snapshot.data
                          ?.map(
                            (vehicleType) => DropdownMenuItem(
                              value: vehicleType,
                              child: Text(vehicleType),
                            ),
                          )
                          .toList(),
                      onChanged: (newValue) => setState(
                        () {
                          _vehicleType = newValue!;
                          _vehicleMake = null;
                          _vehicleModel = null;
                        },
                      ),
                      value: _vehicleType ?? null,
                    );
                  },
                ),
                if (_vehicleType != null)
                  FutureBuilder(
                    future: _getVehiclesMakeList(_vehicleType!),
                    builder: (ctx, snapshot) {
                      print('Hello: ${snapshot.data}');
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      return DropdownButtonFormField(
                        key: const ValueKey('vehicleMake'),
                        onSaved: (value) {
                          _vehicleMake = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Choose Vehicle Make',
                        ),
                        items: snapshot.data
                            ?.map(
                              (vehicleMake) => DropdownMenuItem(
                                value: vehicleMake,
                                child: Text(vehicleMake),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) => setState(
                          () {
                            _vehicleMake = newValue!;
                            _vehicleModel = null;
                          },
                        ),
                        value: _vehicleMake ?? null,
                      );
                    },
                  ),
                if (_vehicleType != null && _vehicleMake != null)
                  FutureBuilder(
                    future: _getVehicleModelsList(_vehicleType!, _vehicleMake!),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      return DropdownButtonFormField(
                        key: const ValueKey('vehicleModel'),
                        onSaved: (value) {
                          _vehicleModel = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Choose Vehicle Model',
                        ),
                        items: snapshot.data
                            ?.map(
                              (vehicleModel) => DropdownMenuItem(
                                value: vehicleModel,
                                child: Text(vehicleModel),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) => setState(
                          () {
                            _vehicleModel = newValue;
                          },
                        ),
                        value: _vehicleModel ?? null,
                      );
                    },
                  ),
                UserImagePicker(imagePickFn: _pickedImage),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _trySubmit();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
