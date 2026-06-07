import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/all/unified_setting_controller.dart';
import 'package:gr_flutter/controllers/student_controller/student_setting_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

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
              image: AssetImage(AppConstants.defaultBackgroundImage),
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
                        icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10),
                  // أيقونة التوثيق الدائرية
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.blue, blurRadius: 20, spreadRadius: 1)
                        ],
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.real_estate_agent_outlined, color: Colors.white, size: 60),
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
                        color: Colors.blue,
                        shadows: [Shadow(color: Colors.white, blurRadius: 5)],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // حاوية المحتوى (النص التوضيحي + رفع الملف)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(50, 10),
                        bottomLeft: Radius.elliptical(10, 50),
                        topRight: Radius.elliptical(10, 50),
                        bottomRight: Radius.elliptical(50, 10),
                      ),
                      border: Border.all(color: Colors.blue, width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'قم بتحميل صورة واضحة للبطاقة الجامعية لإثبات هويتك.',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'صورة البطاقة الجامعية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 15),
                        // مربع رفع الصورة بنفس تصميم الحاويات المائلة
                        InkWell(
                          onTap: () async {
                            await controller.uploadVerifyDocument();
                            controller.update();
                          },
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(40, 10),
                                bottomLeft: Radius.elliptical(10, 40),
                                topRight: Radius.elliptical(10, 40),
                                bottomRight: Radius.elliptical(40, 10),
                              ),
                              border: Border.all(color: Colors.blue, width: 2, style: BorderStyle.solid),
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8)],
                            ),
                            child: controller.document != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.elliptical(40, 10),
                                      bottomLeft: Radius.elliptical(10, 40),
                                      topRight: Radius.elliptical(10, 40),
                                      bottomRight: Radius.elliptical(40, 10),
                                    ),
                                    child: Image.file(
                                      controller.document!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.blue),
                                        SizedBox(height: 10),
                                        Text(
                                          'اضغط لرفع الصورة',
                                          style: TextStyle(color: Colors.blue, fontSize: 14),
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
                          icon: Icon(Icons.send, color: Colors.white),
                          label: Text(
                            'طلب التوثيق',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(1, 10),
                                topRight: Radius.elliptical(10, 1),
                                bottomLeft: Radius.elliptical(10, 1),
                                bottomRight: Radius.elliptical(1, 10),
                              ),
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