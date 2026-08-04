

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/models/admin_models/course_model.dart';
import 'package:gr_flutter/models/public_models/profile_model.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';

class AddLessonsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();

  AddLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: GetBuilder<AdminRequestControllerImpl>(
          builder: (_) {
            final categoryName = controller.categorys.firstWhere(
              (c) => c['id'] == controller.selectedCategoryId,
              orElse: () => {'category': 'غير محددة'},
            )['category'];
            return Text(" الفئة: $categoryName",style: const TextStyle(fontSize: 16),);
          },
        ),
        actions: [
          GetBuilder<AdminRequestControllerImpl>(
            builder: (_) {
              return DropdownButton<String>(
                hint: const Text("اختر الفئة"),
                value: controller.selectedCategoryId.isEmpty
                    ? null
                    : controller.selectedCategoryId,
                items: controller.categorys.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'],
                    child: Text(item['category'] ?? "بدون اسم"),
                  );
                }).toList(),
                onChanged: (newId) {
                  if (newId != null && newId != controller.selectedCategoryId) {
                    controller.selectedCategoryId = newId;
                    controller.clearLessonsQueue();
                    controller.update();
                  }
                },
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (controller) {
          final days = AppConstants.days;
          final periods = AppConstants.periodLessons;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(color: AppColors.grey300),
                      columnWidths: {
                        0: const FixedColumnWidth(100), // عمود الأيام
                        for (int i = 0; i < periods.length; i++)
                          i + 1: const FixedColumnWidth(150), // أعمدة الفترات
                      },
                      children: [
                        // ---------- صف العناوين ----------
                        TableRow(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: AppColors.grey200,
                              child: const Text(
                                "اليوم \\ الفترة",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ...periods.map((period) => Container(
                                  padding: const EdgeInsets.all(8),
                                  color: AppColors.grey200,
                                  child: Text(
                                    period,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                        // ---------- صفوف الأيام ----------
                        ...days.map((day) {
                          return TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: AppColors.grey200,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              ...periods.map((period) {
                                // 🔹 استخدام firstWhereOrNull لتجنب الخطأ
                                final lesson = controller.lessonsQueue
                                    .firstWhereOrNull(
                                        (l) => l['time'] == '$day-$period');
                                return _buildCell(
                                  context,
                                  day,
                                  period,
                                  lesson,
                                  controller,
                                );
                              }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              // زر حفظ الكل
              Padding(
                padding: const EdgeInsets.all(16),
                child: BottonContainer(
                  body: "حفظ الدروس (${controller.lessonsQueue.length})",
                  onTap: controller.lessonsQueue.isEmpty
                      ? null
                      : () {
                          controller.submitLessons();
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String day,
    String period,
    Map<String, dynamic>? lesson, // ⬅️ أصبح nullable
    AdminRequestControllerImpl controller,
  ) {
    if (lesson != null) {
      // عرض الدرس الموجود
      final courseName = controller.courses.firstWhere(
        (c) => c.sId == lesson['course'],
        orElse: () => CourseModel(sId: '', courseName: 'غير معروف'),
      ).courseName ?? 'غير معروف';

      final overseersIds = lesson['overseers'] as List? ?? [];
      final overseersNames = overseersIds.map((id) {
        final overseer = controller.overSeers.firstWhere(
          (o) => o.user == id,
          orElse: () => ProfileModel(firstName: 'غير معروف', lastName: ''),
        );
        return "${overseer.firstName ?? ''} ${overseer.lastName ?? ''}".trim();
      }).join('، ');

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          border: Border.all(color: AppColors.success.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(courseName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("قاعة: ${lesson['hall']}", style: const TextStyle(fontSize: 12)),
            Text(
              overseersNames.length > 20 ? '${overseersNames.substring(0, 20)}...' : overseersNames,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error, size: 16),
              onPressed: () {
                controller.lessonsQueue.removeWhere(
                  (l) => l['time'] == '$day-$period',
                );
                controller.update();
              },
            ),
          ],
        ),
      );
    } else {
      // خلية فارغة → زر إضافة
      return InkWell(
        onTap: () {
          if (controller.selectedCategoryId.isEmpty) {
            Get.snackbar("تنبيه", "يرجى اختيار الفئة أولاً من الأعلى");
            return;
          }
          controller.showAddLessonDialog(context, day, period);
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            border: Border.all(color: AppColors.grey300),
          ),
          child: const Center(
            child: Icon(Icons.add_circle_outline, color: AppColors.grey),
          ),
        ),
      );
    }
  }
}
