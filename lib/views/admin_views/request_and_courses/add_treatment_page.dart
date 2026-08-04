import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/models/admin_models/course_model.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';

class AddTreatmentPage extends StatelessWidget {
  final AdminRequestControllerImpl controller = Get.find<AdminRequestControllerImpl>();

  AddTreatmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(actions: [], title: "إضافة معالجة", centerTitle: true),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.treatmentCaseController,
                  decoration: const InputDecoration(
                    labelText: "اسم المعالجة",
                    hintText: "مثال: قلع أسنان",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الرجاء إدخال اسم المعالجة";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  "اختيار المادة الدراسية (اختياري)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownSearch<CourseModel>(
                  compareFn: (item1, item2) => item1.courseName == item2.courseName,
                  items: (filter, infiniteScrollProps) {
                    if (filter.isEmpty) return controller.courses;
                    return controller.courses
                        .where((course) => course.courseName!
                            .toLowerCase()
                            .contains(filter.toLowerCase()))
                        .toList();
                  },
                  onChanged: (CourseModel? value) {
                    if (value != null) {
                      controller.selectedCourse = value;
                    }
                  },
                  selectedItem: controller.selectedCourse,
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem?.courseName ?? "اختر المادة...",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration(milliseconds: 300),
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "ابحث عن مادة...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // التحقق من صحة المدخلات
                      final treatmentName = controller.treatmentCaseController.text.trim();
                      if (treatmentName.isEmpty) {
                        Get.snackbar("تنبيه", "الرجاء إدخال اسم المعالجة");
                        return;
                      }
                      // إذا كان اختيار المادة إجباريًا أضف هذا الشرط:
                      // if (controller.selectedCourse == null) {
                      //   Get.snackbar("تنبيه", "الرجاء اختيار المادة");
                      //   return;
                      // }
                      controller.addTreatment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "حفظ المعالجة",
                      style: TextStyle(fontSize: 18,color: AppColors.white),
                    ),
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