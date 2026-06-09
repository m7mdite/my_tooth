import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';

import '../../../models/public_models/profile_model.dart';
import '../../request_views/modified_request.dart';

class AddLessonsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  AddLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة درس")),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              // SelectFromItemsMap(
              //         items: controller.courses,
              //         selectedId:
              //             controller.courses.isNotEmpty
              //                 ? controller.courses[0]['id']
              //                 : null,
              //         title: "حدد المادة",
              //         onChanged: (value) {
              //           controller.courseModel.caseType!.sId = value!;
              //           controller.update();
              //         },
              //       ),
              // SizedBox(height: 20,),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("حدد الفئة   "),
                    DropdownButton<String>(
                      hint: Text("حدد الفئة"),
                      value: controller.selectedCategoryId == ""
                          ? null
                          : controller.selectedCategoryId,
                      items: controller.categorys.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['id'],
                          child: Text(item['category'] ?? "no name"),
                        );
                      }).toList(),
                      focusColor: const Color.fromARGB(45, 158, 158, 158),
                      borderRadius: BorderRadius.circular(30),
                      onChanged: (newId) {
                        if (newId != null) {
                          controller.selectedCategoryId = newId;
                          
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("حدد المادة   "),
                    DropdownButton<String>(
                      hint: Text("حدد المادة"),
                      value: controller.selectedCourseId == ""
                          ? null
                          : controller.selectedCourseId,
                      items: controller.courses.map((item) {
                        return DropdownMenuItem<String>(
                          value: item.sId,
                          child: Text(item.courseName ?? "no name"),
                        );
                      }).toList(),
                      focusColor: const Color.fromARGB(45, 158, 158, 158),
                      borderRadius: BorderRadius.circular(30),
                      onChanged: (newId) {
                        if (newId != null) {
                          controller.selectedCourseId = newId;
                          
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              // ✅ الاختيار المتعدد للمشرفين
              Center(
                child: DropdownSearch<ProfileModel>.multiSelection(
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
                  compareFn: (item1, item2) => item1.user == item2.user,
                
                  // التعامل مع التغيير (قائمة من العناصر المختارة)
                  onChanged: (List<ProfileModel>? selectedItems) {
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
                  itemAsString: (ProfileModel? overseer) =>
                      "${overseer!.firstName} ${overseer.lastName}",
                
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SelectFromItems(
                items: AppConstants.days,
                value: AppConstants.days[0],
                title: "اختر اليوم",
                onChanged: (value) {
                  controller.day = value!;
                  controller.update();
                },
              ),
              SelectFromItems(
                items: AppConstants.periodLessons,
                value: AppConstants.periodLessons[0],
                title: "اختر الفترة",
                onChanged: (value) {
                  controller.periodLesson = value!;
                  controller.update();
                },
              ),
              SizedBox(
                height: 20,
              ),
              SelectFromItems(
                items: AppConstants.hall,
                value: AppConstants.hall[0],
                title: "اختر القاعة",
                onChanged: (value) {
                  controller.hall = value!;
                  controller.update();
                },
              ),

              SizedBox(
                height: 20,
              ),
              Center(
                child: BottonContainer(
                  body: "اضافة",
                  onTap: () {
                    controller.addLesson();
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
