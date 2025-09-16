import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagepicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagepicker> {
  File? _pickImageFile;

  void _imagePicker() async {
    final imageSelected = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 50,
      maxHeight: 50,
    );

    if (imageSelected == null) {
      return;
    }

    setState(() {
      _pickImageFile = File(imageSelected.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.deepPurple.shade300,
          foregroundImage: _pickImageFile != null
              ? FileImage(_pickImageFile!)
              : null,
        ),
        TextButton.icon(
          onPressed: _imagePicker,
          icon: Icon(Icons.image),
          label: Text(
            'data',
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
