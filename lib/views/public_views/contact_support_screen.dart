import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/support_controller.dart'; // سننشئه
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

class ContactSupportScreen extends StatelessWidget {
  final SupportController controller = Get.put(SupportController());

  ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                // زر العودة
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // أيقونة الدعم
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
                    child: Icon(Icons.support_agent_outlined, color: Colors.white, size: 60),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'مراسلة الدعم',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      shadows: [Shadow(color: Colors.white, blurRadius: 5)],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // نموذج المراسلة
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
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // حقل الموضوع
                        TextFormField(
                          controller: controller.subjectController,
                          decoration: InputDecoration(
                            labelText: 'الموضوع',
                            prefixIcon: Icon(Icons.subject, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'الرجاء إدخال الموضوع' : null,
                        ),
                        SizedBox(height: 16),
                        // حقل الرسالة
                        TextFormField(
                          controller: controller.messageController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: 'الرسالة',
                            prefixIcon: Icon(Icons.message, color: Colors.blue),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'الرجاء كتابة الرسالة' : null,
                        ),
                        SizedBox(height: 24),
                        // زر الإرسال
                        Center(
                          child: Obx(() => ElevatedButton.icon(
                            onPressed: controller.isLoading.value ? null : () => controller.sendMessage(),
                            icon: controller.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                : Icon(Icons.send),
                            label: Text(controller.isLoading.value ? 'جاري الإرسال...' : 'إرسال'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(1, 10),
                                  topRight: Radius.elliptical(10, 1),
                                  bottomLeft: Radius.elliptical(10, 1),
                                  bottomRight: Radius.elliptical(1, 10),
                                ),
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}