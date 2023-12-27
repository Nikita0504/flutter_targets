import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

picImage(ImageSource source) async {
  final ImagePicker _imagePicer = ImagePicker();
  XFile? _file = await _imagePicer.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No images');
}
