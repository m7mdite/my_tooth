import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> uploadPicture() async {
  Completer<File?> completer = Completer(); // لإنتظار النتيجة
  
  await Get.bottomSheet(
    backgroundColor: Colors.white54,
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        Text("حدد طريقة رفع الصورة"),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      completer.complete(File(pickedFile.path)); // أكمل مع الصورة
                      Get.back();
                    } else {
                      completer.complete(null); // أكمل بدون صورة
                      Get.back();
                    }
                  },
                  icon: Icon(Icons.camera, size: 60, color: Colors.blue),
                ),
                Text("الكاميرا"),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      completer.complete(File(pickedFile.path)); // أكمل مع الصورة
                      Get.back();
                    } else {
                      completer.complete(null); // أكمل بدون صورة
                      Get.back();
                    }
                  },
                  icon: Icon(Icons.photo_library_rounded, size: 60, color: Colors.blue),
                ),
                Text("المعرض")
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    ),
  );
  
  return completer.future; // إنتظر النتيجة
}