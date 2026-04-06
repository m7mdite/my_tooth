import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToothLocationMap() {
  Get.dialog(
      Dialog(
        child: Container(
          // height: Get.height * 0.8,
          // width: Get.width * 0.9,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 2, strokeAlign: 7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "اكتب رقم السن بناءً على المخطط التالي",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                "images/images_asnan/tooth_number.png",
                fit: BoxFit.contain,
                // height: 300,
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.transparent);
}
