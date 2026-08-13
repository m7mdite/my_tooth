import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';

import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/app_theme_constants.dart';
import '../../utils/app_constants/colors_constant.dart';

class ViewVerifyPage extends StatelessWidget {
  final UnifiedSettingController controller =
      Get.put(UnifiedSettingController());

  ViewVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.authBackground),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: GetBuilder<UnifiedSettingController>(

            builder: (_) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  // زر العودة المخصص (بنفس نمط باقي التطبيق)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary, blurRadius: 20, spreadRadius: 1)
                        ],
                        color: AppColors.white,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: Icon(Icons.real_estate_agent_outlined, color: AppColors.white, size: 60),
                    ),
                  ),
                  SizedBox(height: 20),
                  // العنوان الرئيسي
                  Center(
                    child: Text(
                      'طلب توثيق الحساب',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        shadows: [Shadow(color: AppColors.white, blurRadius: 5)],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // حاوية المحتوى (النص التوضيحي + رفع الملف)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.95),
                      borderRadius: AppThemeConstants.borderRadius,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      boxShadow: [BoxShadow(color: AppColors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'قم بتحميل صورة واضحة للبطاقة الجامعية لإثبات هويتك.',
                          style: TextStyle(fontSize: 16, color: AppColors.black87),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'صورة البطاقة الجامعية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 15),
                        
                        InkWell(
                          onTap: () async {
                            await controller.uploadVerifyDocument();
                            controller.update();
                          },
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: AppThemeConstants.borderRadius,
                              border: Border.all(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                              color: AppColors.white,
                              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8)],
                            ),
                            child: controller.document != null
                                ? ClipRRect(
                                    borderRadius: AppThemeConstants.borderRadius,
                                    child: Image.file(
                                      controller.document!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload_outlined, size: 50, color: AppColors.primary),
                                        SizedBox(height: 10),
                                        Text(
                                          'اضغط لرفع الصورة',
                                          style: TextStyle(color: AppColors.primary, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 40),
                        // زر طلب التوثيق
                        ElevatedButton.icon(
                          onPressed: () {
                            controller.verifyDocument();
                          },
                          icon: Icon(Icons.send, color: AppColors.white),
                          label: Text(
                            'طلب التوثيق',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryAccent,
                            foregroundColor: AppColors.white,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppThemeConstants.borderRadius,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}