// lib/views/admin_views/request_and_courses/weekly_schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../../models/admin_models/lesson_model.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';

class WeeklyScheduleScreen extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();

  WeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الجدول الأسبوعي",
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.authBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: controller.getSchedule,
          child: Obx(() {
            if (controller.isLoading.value && controller.allLessons.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.allLessons.isEmpty) {
              return const Center(
                child: Text('لا توجد دروس مضافة'),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (controller.year4Lessons.isNotEmpty)
                    _buildScheduleTable(
                      lessons: controller.year4Lessons,
                      title: ' السنة الرابعة',
                      color: Colors.teal,
                      controller: controller,
                      allLessons: controller.allLessons,
                      context: context, // ← تمرير context
                    ),
                  const SizedBox(height: 24),
                  if (controller.year5Lessons.isNotEmpty)
                    _buildScheduleTable(
                      lessons: controller.year5Lessons,
                      title: 'السنة الخامسة',
                      color: AppColors.warning,
                      controller: controller,
                      allLessons: controller.allLessons,
                      context: context,
                    ),
                  if (controller.year4Lessons.isEmpty &&
                      controller.year5Lessons.isEmpty)
                    const Center(
                      child: Text('لا توجد دروس مضافة لهذا الأسبوع'),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ===================== دالة اختصار الفئة =====================
  String _getShortCategory(String? fullCategory) {
    if (fullCategory == null || fullCategory.isEmpty) return '';
    final match = RegExp(r'\.(\d+)').firstMatch(fullCategory);
    if (match != null) {
      return 'ف${match.group(1)}';
    }
    final numMatch = RegExp(r'^(\d+)').firstMatch(fullCategory);
    if (numMatch != null) {
      return 'ف${numMatch.group(1)}';
    }
    return fullCategory;
  }

  // ===================== دالة عرض أسماء المشرفين =====================
  String _getOverseersNames(List<OverseerInfo>? overseers) {
    if (overseers == null || overseers.isEmpty) return '';
    return overseers
        .map((o) => '${o.firstName ?? ''} ${o.lastName ?? ''}'.trim())
        .where((s) => s.isNotEmpty)
        .join('، ');
  }

  // ===================== دالة فتح حوار التعديل =====================
  void _showEditLessonDialog(BuildContext context, LessonModel lesson) {
    controller.showEditLessonDialog(context, lesson);
  }

  // ===================== بناء الخلية (فارغة أو مملوءة) =====================
  Widget _buildCellContent({
    required LessonModel? period1Lesson,
    required LessonModel? period2Lesson,
    required bool isOccupiedByOther,
    VoidCallback? onLongPress,
  }) {
    final bool hasLesson = period1Lesson != null || period2Lesson != null;

    final Color cellColor = isOccupiedByOther
        ? AppColors.error100
        : (hasLesson
            ? AppColors.primary50
            : AppColors.grey100);

    return GestureDetector(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 150,
        height: 110,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cellColor,
          border: Border(
            right: BorderSide(color: AppColors.grey300, width: 0.5),
            bottom: BorderSide(color: AppColors.grey300, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // النصف الأول (الفترة الأولى 08:00)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: period1Lesson != null
                      ? AppColors.primary50
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: period1Lesson != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            period1Lesson.course?.courseName ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 1),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: (period1Lesson.category?.category ?? '').startsWith('4')
                                  ? Colors.teal.withValues(alpha: 0.2)
                                  : AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getShortCategory(period1Lesson.category?.category),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: (period1Lesson.category?.category ?? '').startsWith('4')
                                    ? Colors.teal.shade700
                                    : AppColors.warning.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Flexible(
                            child: Text(
                              _getOverseersNames(period1Lesson.overseers),
                              style: TextStyle(
                                fontSize: 7,
                                color: AppColors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          '08:00',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            // النصف الثاني (الفترة الثانية 12:00)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: period2Lesson != null
                      ? AppColors.success.shade50
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: period2Lesson != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            period2Lesson.course?.courseName ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 1),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: (period2Lesson.category?.category ?? '').startsWith('4')
                                  ? Colors.teal.withValues(alpha: 0.2)
                                  : AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getShortCategory(period2Lesson.category?.category),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: (period2Lesson.category?.category ?? '').startsWith('4')
                                    ? Colors.teal.shade700
                                    : AppColors.warning.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Flexible(
                            child: Text(
                              _getOverseersNames(period2Lesson.overseers),
                              style: TextStyle(
                                fontSize: 7,
                                color: AppColors.grey700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          '12:00',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== بناء الجدول =====================
  Widget _buildScheduleTable({
    required List<LessonModel> lessons,
    required String title,
    required Color color,
    required AdminRequestControllerImpl controller,
    required List<LessonModel> allLessons,
    required BuildContext context,
  }) {
    final allHalls = controller.getAllHalls();
    final days = controller.getDays(lessons);

    if (allHalls.isEmpty || days.isEmpty) return const SizedBox.shrink();

    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(80, 12),
                bottomLeft: Radius.elliptical(12, 80),
                topRight: Radius.elliptical(12, 80),
                bottomRight: Radius.elliptical(80, 12),
              ),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const Divider(color: AppColors.grey, thickness: 0.5),
                // ===== الجدول مع تمرير موحد =====
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === العمود الثابت (الأيام) ===
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            ...days.map((day) {
                              return Container(
                                width: 50,
                                height: 110,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.grey300, width: 0.5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        // === الجزء القابل للتمرير (القاعات) ===
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                // صف العناوين (القاعات)
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    children: allHalls.map((hall) {
                                      return Container(
                                        width: 150,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          hall,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                // صفوف الأيام
                                ...days.map((day) {
                                  return Row(
                                    children: allHalls.map((hall) {
                                      // جميع الدروس في هذا اليوم والقاعة (من كل السنوات)
                                      final occupiedLessons = allLessons.where(
                                        (l) => l.day == day && l.hall == hall,
                                      ).toList();

                                      // هل القاعة مشغولة بدرس من سنة أخرى؟
                                      final bool isOccupiedByOther = occupiedLessons.any(
                                        (l) => !lessons.contains(l),
                                      );

                                      // الدرس في الفترة الأولى
                                      LessonModel? period1Lesson;
                                      try {
                                        period1Lesson = lessons.firstWhere(
                                          (l) => l.day == day && l.hall == hall && l.period == '08:00',
                                        );
                                      } catch (_) {
                                        period1Lesson = null;
                                      }

                                      // الدرس في الفترة الثانية
                                      LessonModel? period2Lesson;
                                      try {
                                        period2Lesson = lessons.firstWhere(
                                          (l) => l.day == day && l.hall == hall && l.period == '12:00',
                                        );
                                      } catch (_) {
                                        period2Lesson = null;
                                      }

                                      // تحديد الـ onLongPress بناءً على وجود درس
                                      VoidCallback? onLongPress;
                                      if (period1Lesson != null) {
                                        onLongPress = () => _showEditLessonDialog(context, period1Lesson!);
                                      } else if (period2Lesson != null) {
                                        onLongPress = () => _showEditLessonDialog(context, period2Lesson!);
                                      }

                                      return _buildCellContent(
                                        period1Lesson: period1Lesson,
                                        period2Lesson: period2Lesson,
                                        isOccupiedByOther: isOccupiedByOther,
                                        onLongPress: onLongPress,
                                      );
                                    }).toList(),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}