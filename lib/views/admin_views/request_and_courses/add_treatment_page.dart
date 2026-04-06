import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_request_controller.dart';
import 'package:gr_flutter/models/admin/course_model.dart';

class AddTreatmentPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  AddTreatmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة معالجة")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.treatmentCaseController,
            decoration: InputDecoration(
              labelText: "أضف معالجة",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          DropdownSearch<CourseModel>(
            compareFn: (item1, item2) => item1.courseName == item2.courseName,
            items: (filter, infiniteScrollProps) {
              if (filter.isEmpty) {
                return controller.courses;
              }
              return controller.courses
                  .where((course) => course.courseName!
                      .toLowerCase()
                      .contains(filter.toLowerCase()))
                  .toList();
            },
            onChanged: (CourseModel? value) {
              if (value != null) {
                controller.selectedCourse = value;
                print("تم اختيار المادة: ${value.courseName}");
              }
            },
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem?.courseName ?? "اختر المادة...",
                style: TextStyle(fontSize: 16),
              );
            },
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchDelay: Duration(milliseconds: 500),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "ابحث عن كورس...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (controller.treatmentCaseController.text.isEmpty) {
                Get.snackbar("خطأ", "الرجاء إدخال حالة المعالجة");
                return;
              }
              if (controller.selectedCourse == null) {
                Get.snackbar("خطأ", "الرجاء اختيار كورس");
                return;
              }
              controller.addTreatment();
            },
            child: Text("حفظ المعالجة"),
          ),
        ],
      ),
    );
  }
}
