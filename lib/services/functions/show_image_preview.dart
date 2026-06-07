import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showImagePreview(String imageUrl) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(1),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // الصورة القابلة للتكبير داخل الإطار
          Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      width: 200,
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // زر الإغلاق
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: true,
    barrierColor: Colors.black54, // خلفية مغبشة
  );
}