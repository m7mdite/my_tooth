import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';

class AddCoursePage extends StatelessWidget {
  final AdminRequestControllerImpl controller = Get.find<AdminRequestControllerImpl>();

  AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(actions: [], title: "إضافة مادة"),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.courseNameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المادة",
                    hintText: "مثال: جراحة الفم",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الرجاء إدخال اسم المادة";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (controller.courseNameController.text.trim().isEmpty) {
                      Get.snackbar("تنبيه", "الرجاء إدخال اسم المادة");
                      return;
                    }
                    controller.addCourse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "إضافة",
                    style: TextStyle(fontSize: 18,color: AppColors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}