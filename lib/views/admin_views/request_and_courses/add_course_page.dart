import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_request_controller.dart';
import 'package:gr_flutter/models/overseer/profile_overseer_model.dart';

class AddCoursePage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة مادة")),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "اسم المادة",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
          
              // ✅ الاختيار المتعدد للمشرفين
              DropdownSearch<ProfileOverseerModel>.multiSelection(
                // دالة items للبحث والتصفية
                items: (filter, infiniteScrollProps) {
                  if (controller.overSeers.isEmpty) {
                    return [];
                  }
          
                  if (filter.isEmpty) {
                    return controller.overSeers.toList();
                  }
          
                  return controller.overSeers
                      .where((overseer) =>
                          overseer.firstName != null &&
                          overseer.firstName!
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                      .toList();
                },
          
                // مقارنة العناصر
                compareFn: (item1, item2) => item1?.sId == item2?.sId,
          
                // التعامل مع التغيير (قائمة من العناصر المختارة)
                onChanged: (List<ProfileOverseerModel>? selectedItems) {
                  if (selectedItems != null) {
                    controller.selectedOverseers = selectedItems;
                    print("تم اختيار ${selectedItems.length} مشرف");
                  }
                },
          
                // العناصر المختارة مبدئياً
                selectedItems: controller.selectedOverseers,
          
                // عرض العناصر المختارة
                dropdownBuilder: (context, selectedItems) {
                  if (selectedItems.isEmpty) {
                    return Text(
                      "اختر المشرفين...",
                      style: TextStyle(color: Colors.grey[600]),
                    );
                  }
                  return Text(
                    "تم اختيار ${selectedItems.length} مشرف",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  );
                },
          
                // كيفية عرض كل عنصر في القائمة
                itemAsString: (ProfileOverseerModel? overseer) =>
                    overseer?.firstName ?? "اسم غير متوفر",
          
                // إعدادات القائمة المنبثقة للاختيار المتعدد
                popupProps: PopupPropsMultiSelection.menu(
                  showSearchBox: true,
                  searchDelay: Duration(milliseconds: 500),
                  showSelectedItems: true, // عرض المختارة في الأعلى
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "ابحث عن مشرف...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
