import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_request_controller.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

class AddCategoryPage extends StatelessWidget {
  final AdminRequestControllerImpl controller = Get.find<AdminRequestControllerImpl>();

  AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة فئة"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          // إذا كان في حالة تحميل، نعرض مؤشر التحميل
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.categoryController,
                  decoration: const InputDecoration(
                    labelText: "رقم الفئة",
                    hintText: "مثال: 4_طب_أسنان",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الرجاء إدخال رقم الفئة";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // التحقق من صحة الحقل قبل الإضافة
                    if (controller.categoryController.text.trim().isEmpty) {
                      Get.snackbar("تنبيه", "الرجاء إدخال رقم الفئة");
                      return;
                    }
                    controller.addCategory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "إضافة",
                    style: TextStyle(fontSize: 18),
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