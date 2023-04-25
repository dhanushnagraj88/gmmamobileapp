import 'dart:io';

import 'package:flutter/material.dart';

import './image_picker.dart';
import '../../models/vehicles_list.dart';

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
  String? _vehicleTypeOption;
  String? _vehicleMakeOption;
  String? _vehicleModelOption;
  List<String> _vehicleTypeList = [];
  List<String> _vehicleMakeList = [];
  List<String> _vehicleModelsList = [];
  File? _vehicleImageFile;
  final _formKey = GlobalKey<FormState>();

  var _ownerName = '';
  var _vehicleNumber = '';
  var _vehicleType = '';
  var _vehicleMake = '';
  var _vehicleModel = '';

  final modelKey = GlobalKey<FormState>();
  void _pickedImage(File image) {
    _vehicleImageFile = image;
  }

  void _trySubmit() {
    _formKey.currentState!.save();
    widget.submitFn(
      ownerName: _ownerName,
      vehicleNumber: _vehicleNumber,
      vehicleType: _vehicleType,
      vehicleMake: _vehicleMake,
      vehicleModel: _vehicleModel,
      vehicleImage: _vehicleImageFile!,
      ctx: context,
    );
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    key: const ValueKey('name'),
                    decoration: const InputDecoration(labelText: 'Owner Name'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) {
                      _ownerName = value!;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    key: const ValueKey('number'),
                    decoration:
                        const InputDecoration(labelText: 'Vehicle Number'),
                    onSaved: (value) {
                      _vehicleNumber = value!;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    onSaved: (value) {
                      _vehicleType = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Choose Vehicle Type',
                      border: OutlineInputBorder(),
                    ),
                    items: VehiclesList()
                        .typeOfVehicles
                        .map(
                          (val) => DropdownMenuItem(
                            key: ValueKey(val),
                            value: val,
                            child: Text(
                              (val),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) => setState(
                      () {
                        _vehicleTypeOption = newValue;
                        _vehicleMakeOption = '';
                      },
                    ),
                    value: null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    onSaved: (value) {
                      _vehicleMake = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Choose Vehicle Make',
                      border: OutlineInputBorder(),
                    ),
                    items: VehiclesList()
                        .vehicleMakeList
                        .map(
                          (val) => DropdownMenuItem(
                            key: ValueKey(val),
                            value: val,
                            child: Text(
                              (val),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) {
                      setState(
                        () {
                          _vehicleMakeOption = newValue!;
                          _vehicleModelsList =
                              VehiclesList().getModelsForMake(newValue);
                        },
                      );
                    },
                    value: null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    // key: modelKey,
                    decoration: const InputDecoration(
                      labelText: 'Choose Vehicle Model',
                      border: OutlineInputBorder(),
                    ),
                    items: _vehicleModelsList
                        .map(
                          (val) => DropdownMenuItem(
                            value: val,
                            child: Text(
                              (val),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) => setState(
                      () {
                        _vehicleModelOption = newValue!;
                      },
                    ),
                    onSaved: (value) {
                      _vehicleModel = value!;
                    },
                    value: null,
                  ),
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
