import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

void showsnack( {String? title, String? message}) {
  // يجب أن يكون التطبيق مغلفًا بـ GetMaterialApp
  Get.showSnackbar(
    GetSnackBar(
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      // تعيين الخلفية كلون شفاف لإظهار الصورة
      backgroundColor: Colors.transparent,
      // منع المحتوى من أخذ مساحة إضافية
      padding: EdgeInsets.zero,
      margin: EdgeInsets.all(10),
      borderRadius: 16,
      // استخدام messageText لعرض واجهة المستخدم المخصصة
      messageText: Container(
        decoration: BoxDecoration(
          // هنا نحدد الصورة كخلفية
          image: DecorationImage(
            image: AssetImage(AppConstants.defaultBackgroundImage), // استبدل هذا بالرابط الصحيح للصورة
            fit: BoxFit.cover, // تغطية المساحة بالكامل
            colorFilter: ColorFilter.linearToSrgbGamma()
          ),
          borderRadius: BorderRadius.circular(16), // تناسق مع حواف GetSnackBar
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title??" عنوان التنبيه",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                message??" هذه هي رسالة التنبيه التي تظهر على الصورة.",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}