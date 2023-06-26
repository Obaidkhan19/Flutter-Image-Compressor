import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class CompressImageSCreen extends StatefulWidget {
  const CompressImageSCreen({super.key});

  @override
  State<CompressImageSCreen> createState() => _CompressImageSCreenState();
}

class _CompressImageSCreenState extends State<CompressImageSCreen> {
  File? newImage;

  XFile? image;

  final picker = ImagePicker();

  // method to pick single image while replacing the photo
  Future imagePickerFromGallery() async {
    image = (await picker.pickImage(source: ImageSource.gallery))!;

    final bytes = await image!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;

    if (kDebugMode) {
      print('original image size:$mb');
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:$newMb');
    }

    newImage = File(result.path);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ADD 2 PERMISSION IN MANIFEST FILES
    //  <uses-permission android:name="android.permission.WRITE_INTERNAL_STORAGE" />
    // <uses-permission android:name="android.permission.READ_INTERNAL_STORAGE" />

    // ADD 3 PKG
    //   image_picker:
    // flutter_image_compress: ^2.0.3
    //path_provider:

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compress Image'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Text("Compress Image"),
          if (image != null)
            SizedBox(
              child: Image.file(
                File(newImage!.path),
                fit: BoxFit.fitHeight,
              ),
            ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imagePickerFromGallery();
        },
      ),
    );
  }
}
