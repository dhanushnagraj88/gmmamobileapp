import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    Key? key,
    required this.imagePicker,
  }) : super(key: key);

  final Function(File pickedImage) imagePicker;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(
      () {
        if (pickedImageFile != null) {
          _pickedImage = File(pickedImageFile.path);
        }
      },
    );
    widget.imagePicker(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 150,
          child: _pickedImage == null
              ? const Center(
                  child: Text('No image Taken'),
                )
              : Image.file(_pickedImage!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera),
          label: const Text('Take a Picture '),
        ),
      ],
    );
  }
}
