import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

import '../../utils/app_constants/colors_constant.dart';

showToothLocationMap() {
  Get.dialog(
      Dialog(
        child: Container(
          // height: Get.height * 0.8,
          // width: Get.width * 0.9,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(color: AppColors.borderColor, width: 2, strokeAlign: 7),
            borderRadius: AppThemeConstants.borderRadius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "اكتب رقم السن بناءً على المخطط التالي",
                style: TextStyle(
                  color: AppColors.white,
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
      barrierColor: AppColors.transparent);
}
