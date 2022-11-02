// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Image Picker Demo',
        home: MyHomePage(title: 'Image Picker Example'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _imageFile;

  void _setImageFile(XFile? value) => _imageFile = value;

  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      setState(() => _setImageFile(pickedFile));
    } catch (e) {
      setState(() => _pickImageError = e);
    }
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) return retrieveError;
    if (_imageFile != null) {
      return Image.file(File(_imageFile!.path));
    } else if (_pickImageError != null) {
      return Text('Pick image error: $_pickImageError',
          textAlign: TextAlign.center);
    } else {
      return const Text('You have not yet picked an image.',
          textAlign: TextAlign.center);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Center(child: _previewImage()),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () =>
                    _onImageButtonPressed(ImageSource.camera, context: context),
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      );

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
