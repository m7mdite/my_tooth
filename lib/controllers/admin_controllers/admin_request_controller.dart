import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_users_controller.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';

import '../../models/admin_models/course_model.dart';
import '../../models/admin_models/lesson_model.dart';
import '../../models/public_models/profile_model.dart';
import '../../models/requests_models/treatment_request_model.dart';
import '../../models/requests_models/treatment_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/admin_remotes/admin_remote.dart';
import '../../utils/app_constants/app_constants.dart';
import '../../utils/app_constants/status_request.dart';

abstract class AdminRequestController extends GetxController {
  toAddCoursePage();
  toAddTreatmentPage();
  toAddLessonsPage();
  getSchedule();
  toAddCategoryPage();
  toViewLessons();
  toViewTreatmentsPage();
  toViewCoursesPage();
  toViewCategorysPage();
  toViewPendingRequestsPage();
  toViewInProcessingRequestsPage();
  toViewFinishedRequestsPage();
  toViewRejectedRequestsPage();
  addTreatment();
  addCourse();
  // addLesson();
  addCategory();
  getAllTreatments();
  getAllCourses();
  getAllOverSeers();
  getAllCategory();
  getAllPendingRequests();
  getAllInProcessingRequests();
  getAllFinishedRequests();
  getAllRejectedRequests();
  deleteCategory(String id);
  // دوال جديدة لإدارة الدروس المتعددة
  void addLessonToQueue(); // يضيف الدرس الحالي إلى القائمة
  void removeLessonFromQueue(int index); // يحذف درساً من القائمة
  void submitLessons(); // يرسل كل الدروس المضافة
  void clearLessonsQueue(); // (اختياري) لمسح القائمة بعد الإرسال
}

class AdminRequestControllerImpl extends AdminRequestController {
  AdminUsersControllerImpl adminUsersControllerImpl =
      Get.put(AdminUsersControllerImpl());
  List<Map<String, dynamic>> lessonsQueue = [];
  late StatusRequest statusRequest;
  AdminRemote adminRemote = AdminRemote(Get.find());
  List<TreatmentModel> treatments = [];
  List<CourseModel> courses = [];
  List<ProfileModel> overSeers = [];
  // List lessons = [];
  List<Map<String, String>> categorys = [];
  List<TreatmentRequestModel> pendingRequests = [];
  List<TreatmentRequestModel> inProcessingRequests = [];
  List<TreatmentRequestModel> finishedRequests = [];
  List<TreatmentRequestModel> rejectedRequests = [];
  Map category = {};
  Map<String, dynamic> lesson = {};
  RxList<LessonModel> lessons = <LessonModel>[].obs;
  RxList<LessonModel> allLessons = <LessonModel>[].obs;
  RxList<LessonModel> filteredLessons = <LessonModel>[].obs;
  RxList<LessonModel> year4Lessons = <LessonModel>[].obs;
  RxList<LessonModel> year5Lessons = <LessonModel>[].obs;
  List<ProfileModel> selectedOverseers = <ProfileModel>[];
  CourseModel? selectedCourse;
  String selectedCourseId = "";
  String selectedCategoryId = "";
  String selectedDay = "";
  // String time ="$";

  RxBool isLoading = false.obs;

  TextEditingController courseNameController = TextEditingController();
  TextEditingController treatmentCaseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
// ========= variable for time
  String day = "";
  String periodLesson = "";
  String hall = "";

  RxString selectedYear = 'الكل'.obs;
  final List<String> years = ['الكل', '4', '5'];
  final List<String> daysOrder = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس'
  ];
  final List<String> periods = [
    'الفترة الأولى',
    'الفترة الثانية'
  ]; // ضبط حسب وقتك

  @override
  void onInit() {
    getAllCourses();
    super.onInit();
  }

  @override
  Future<void> getSchedule() async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    final response = await adminRemote.getWeeklySchedule();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      final List<dynamic> data = response['data'] ?? [];
      allLessons.value =
          data.map((json) => LessonModel.fromJson(json)).toList();
      _filterByYear();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل الجدول');
    }
    isLoading.value = false;
  }

  // دالة لجلب جميع القاعات من جميع الدروس (للسنة الحالية أو الكل)
  List<String> getAllHalls() {
    final Set<String> halls = {};
    for (var lesson in allLessons) {
      if (lesson.hall != null && lesson.hall!.isNotEmpty) {
        halls.add(lesson.hall!);
      }
    }
    return halls.toList()..sort();
  }

// دالة للحصول على الأيام الفريدة من قائمة الدروس (مرتبة)
  List<String> getDays(List<LessonModel> lessons) {
    final Set<String> days = {};
    for (var lesson in lessons) {
      if (lesson.day.isNotEmpty) {
        days.add(lesson.day);
      }
    }
    final order = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
    return days.toList()
      ..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
  }

// دالة للحصول على درس في خلية محددة (يوم + قاعة)
  LessonModel? getLessonForCell(
      List<LessonModel> lessons, String day, String hall) {
    try {
      return lessons.firstWhere(
        (lesson) => lesson.day == day && lesson.hall == hall,
      );
    } catch (_) {
      return null;
    }
  }

  // تصفية الدروس حسب السنة
  void _filterByYear() {
    year4Lessons.value = allLessons.where((lesson) {
      final cat = lesson.category?.category ?? '';
      return cat.startsWith('4.');
    }).toList();

    year5Lessons.value = allLessons.where((lesson) {
      final cat = lesson.category?.category ?? '';
      return cat.startsWith('5.');
    }).toList();
  }

  // الحصول على قائمة القاعات الفريدة من الدروس
  List<String> getHalls(List<LessonModel> lessons) {
    final Set<String> halls = {};
    for (var lesson in lessons) {
      if (lesson.hall != null && lesson.hall!.isNotEmpty) {
        halls.add(lesson.hall!);
      }
    }
    return halls.toList()..sort();
  }

  // الحصول على قائمة الأيام الفريدة من الدروس (مرتبة)
  // List<String> getDays(List<LessonModel> lessons) {
  //   final Set<String> days = {};
  //   for (var lesson in lessons) {
  //     if (lesson.day.isNotEmpty) {
  //       days.add(lesson.day);
  //     }
  //   }
  //   // ترتيب حسب daysOrder
  //   return days.toList()..sort((a, b) => daysOrder.indexOf(a).compareTo(daysOrder.indexOf(b)));
  // }

  // الحصول على الدرس في خلية محددة (يوم + قاعة)
  // LessonModel? getLessonForCell(List<LessonModel> lessons, String day, String hall) {
  //   try {
  //     return lessons.firstWhere(
  //       (lesson) => lesson.day == day && lesson.hall == hall,
  //     );
  //   } catch (_) {
  //     return null;
  //   }
  // }

  void applyFilter() {
    if (selectedYear.value == 'الكل') {
      filteredLessons.value = allLessons;
    } else {
      filteredLessons.value = allLessons.where((lesson) {
        final cat = lesson.category?.category ?? '';
        return cat.startsWith(selectedYear.value);
      }).toList();
    }
  }

  void setYear(String year) {
    selectedYear.value = year;
    applyFilter();
  }

  // دالة للحصول على الدرس في خلية محددة
  LessonModel? getLesson(String day, String period) {
    try {
      return filteredLessons.firstWhere(
        (lesson) => lesson.day == day && lesson.period == period,
      );
    } catch (_) {
      return null;
    }
  }

  // استخراج قائمة الفترات الفعلية من البيانات (اختياري)
  List<String> get actualPeriods {
    final Set<String> periodsSet = {};
    for (var lesson in filteredLessons) {
      if (lesson.period.isNotEmpty) periodsSet.add(lesson.period);
    }
    return periodsSet.toList()..sort();
  }

  // استخراج قائمة الأيام الفعلية من البيانات (اختياري)
  // List<String> get actualDays {
  //   final Set<String> daysSet = {};
  //   for (var lesson in filteredLessons) {
  //     if (lesson.day.isNotEmpty) daysSet.add(lesson.day);
  //   }
  //   return daysSet.toList()..sort((a, b) => days.indexOf(a).compareTo(days.indexOf(b)));
  // }
  // List<String> getAllHalls() {
  //   final Set<String> halls = {};
  //   for (var lesson in allLessons) {
  //     if (lesson.hall != null && lesson.hall!.isNotEmpty) {
  //       halls.add(lesson.hall!);
  //     }
  //   }
  //   return halls.toList()..sort();
  // }

  // void applyFilter() {
  //   if (selectedYear.value == 'الكل') {
  //     filteredLessons.value = allLessons;
  //   } else {
  //     filteredLessons.value = allLessons.where((lesson) {
  //       final cat = lesson.category ?? '';
  //       // final cat = lesson.category?.categoryName ?? '';
  //       return cat.startsWith(selectedYear.value);
  //     }).toList();
  //   }
  // }

  // void setYear(String year) {
  //   selectedYear.value = year;
  //   applyFilter();
  // }

  List<LessonModel> getLessonsForDay(String day) {
    return filteredLessons.where((lesson) => lesson.day == day).toList();
  }

  // دالة للحصول على الدرس في خلية معينة (اليوم، الوقت)
  // LessonModel? getLesson(String day, String period) {
  //   try {
  //     return lessons.firstWhere(
  //       (lesson) {
  //         if (lesson.time == null) return false;
  //         final parts = lesson.time!.split('-');
  //         if (parts.length != 2) return false;
  //         final lessonDay = parts[0].trim();
  //         final lessonTime = parts[1].trim();
  //         return lessonDay == day && lessonTime == period;
  //       },
  //     );
  //   } catch (_) {
  //     return null;
  //   }
  // }

  @override
  toAddCoursePage() {
    overSeers = getAllOverSeers();
    // showsnack();
    Get.toNamed(AppRroute.addCourse);
  }

  @override
  toAddTreatmentPage() {
    getAllTreatments();
    Get.toNamed(AppRroute.addTreatment);
  }

  @override
  toViewCoursesPage() {
    getAllCourses();

    Get.toNamed(AppRroute.viewCourses);
  }

  @override
  toViewTreatmentsPage() {
    getAllTreatments();
    Get.toNamed(AppRroute.viewTreatments);
  }

  @override
  toViewLessons() {
    getSchedule();
    Get.toNamed(AppRroute.viewLessons);
  }

  @override
  addTreatment() async {
    if (selectedCourse == null) {
      showsnack(title: "خطأ", message: "الرجاء اختيار كورس");
      return;
    }
    if (treatmentCaseController.text.trim().isEmpty) {
      showsnack(title: "خطأ", message: "الرجاء إدخال حالة المعالجة");
      return;
    }
    Map data = {
      "case_type": treatmentCaseController.text,
      "course": selectedCourse!.sId,
    };
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addTreatment(data);
    statusRequest = handlingData(response);
    print("$statusRequest");
    if (statusRequest == StatusRequest.success) {
      // print("${response}");
      Get.back();
      Get.back();
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    } else {
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    }
    update();
  }

  @override
  addCourse() async {
    statusRequest = StatusRequest.loading;
    update();
    if (courseNameController.text.trim().isEmpty) {
      showsnack(title: "خطأ", message: "الرجاء إدخال اسم الكورس");
      return;
    }
    var response =
        await adminRemote.addCourse({"course_name": courseNameController.text});
    statusRequest = handlingData(response);
    update();
    if (statusRequest == StatusRequest.success) {
      Get.back();
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    } else {
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    }
    update();
  }

  @override
  getAllCourses() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllCourses();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      courses = (response['data'] as List)
          .map((course) => CourseModel.fromJson(course))
          .toList();

      showsnack(title: "Success", message: "Courses loaded successfully");
    } else {
      showsnack(title: "Error", message: "Failed to load courses");
    }
    update();
  }

  @override
  getAllTreatments() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllTreatments();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      treatments = (response['data'] as List)
          .map((treatment) => TreatmentModel.fromJson(treatment))
          .toList();
      // print("${response['data']}");
      print(" ${treatments.length} treatments loaded successfully");

      showsnack(title: "Success", message: "Treatments loaded successfully");
    }
    update();
  }

  @override
  List<ProfileModel> getAllOverSeers() {
    adminUsersControllerImpl.getAllOverSeers();
    // print("${adminUsersControllerImpl.overSeers[1]}");
    return adminUsersControllerImpl.overSeers;
  }

  @override
  toAddLessonsPage() {
    overSeers = getAllOverSeers();
    getAllCourses();
    getAllCategory();
    Get.toNamed(AppRroute.addLessons);
  }

  // @override
  // addLessons() async {
  //   lesson = {
  //     "course": selectedCourseId,
  //     "category": selectedCategoryId,
  //     "overseers": selectedOverseers.map((o) => o.user).toList(),
  //     "time": "$day-$periodLesson",
  //     "hall": hall
  //   };
  //   print("====================$lesson");
  //   statusRequest = StatusRequest.loading;
  //   update();
  //   var response = await adminRemote.addLessons(lesson);
  //   statusRequest = handlingData(response);
  //   print("+++++++++++++++++++++++++++$response");
  //   // if(statusRequest == StatusRequest.success){
  //   // showsnack(title: response['status'], message: response['message']);
  //   // }
  //   // Get.back();
  //   update();
  // }

  @override
  toAddCategoryPage() {
    Get.toNamed(AppRroute.addCategory);
  }

  @override
  toViewCategorysPage() {
    getAllCategory();
    Get.toNamed(AppRroute.viewCategorys);
    update();
  }

  @override
  addCategory() async {
    Map c = {"category": categoryController.text};
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addCategory(c);
    statusRequest = handlingData(response);
    // if(statusRequest == StatusRequest.success){
    showsnack(title: response['status'], message: response['message']);
    // }
    Get.back();
    update();
  }

  @override
  getAllCategory() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllCategory();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      categorys = (response['data'] as List)
          .map((c) => {
                "id": c['_id'] as String,
                "category": c['category'] as String,
              })
          .toList();
      // print("${response['data']}");
      print(" ${categorys.length} categorys loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  toViewFinishedRequestsPage() {
    getAllFinishedRequests();
    Get.toNamed(AppRroute.viewFinishedRequests);
  }

  @override
  toViewInProcessingRequestsPage() {
    getAllInProcessingRequests();
    Get.toNamed(AppRroute.viewInProcessingRequests);
  }

  @override
  toViewPendingRequestsPage() {
    getAllPendingRequests();
    Get.toNamed(AppRroute.viewPendingRequests);
  }

  @override
  toViewRejectedRequestsPage() {
    getAllRejectedRequests();
    Get.toNamed(AppRroute.viewRejectedRequests);
  }

  @override
  getAllFinishedRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getCompletedRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      finishedRequests = (response['data'] as List)
          .map((c) => TreatmentRequestModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(
          " ${finishedRequests.length} in-processing requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  getAllInProcessingRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllInProcessingRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      inProcessingRequests = (response['data'] as List)
          .map((c) => TreatmentRequestModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(
          " ${inProcessingRequests.length} in-processing requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  getAllPendingRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllPendingRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      pendingRequests = (response['data'] as List)
          .map((c) => TreatmentRequestModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(" ${pendingRequests.length} pending requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  getAllRejectedRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllRejectedRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      rejectedRequests = (response['data'] as List)
          .map((c) => TreatmentRequestModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(
          " ${rejectedRequests.length} rejected requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  Future<void> deleteCategory(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.deleteCategory(id);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      // تحديث القائمة محلياً
      categorys.removeWhere((cat) => (cat['_id'] ?? cat['id']) == id);
      update();
      Get.snackbar('نجاح', 'تم حذف الفئة بنجاح');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الحذف');
    }
    update();
  }

  @override
  void addLessonToQueue() {
    // التحقق من اكتمال البيانات
    if (selectedCourseId.isEmpty) {
      showsnack(title: "خطأ", message: "يرجى اختيار المادة");
      return;
    }
    if (selectedCategoryId.isEmpty) {
      showsnack(title: "خطأ", message: "يرجى اختيار الفئة");
      return;
    }
    if (selectedOverseers.isEmpty) {
      showsnack(title: "خطأ", message: "يرجى اختيار مشرف على الأقل");
      return;
    }
    if (day.isEmpty || periodLesson.isEmpty || hall.isEmpty) {
      showsnack(title: "خطأ", message: "يرجى تحديد اليوم والفترة والقاعة");
      return;
    }

    // بناء كائن الدرس
    Map<String, dynamic> lesson = {
      "course": selectedCourseId,
      "category": selectedCategoryId,
      "overseers": selectedOverseers.map((o) => o.user).toList(),
      "time": "$day-$periodLesson",
      "hall": hall,
    };

    // إضافته إلى القائمة
    lessonsQueue.add(lesson);
    update(); // لتحديث الواجهة

    // إعادة تعيين الحقول (اختياري) لتسهيل إدخال درس آخر
    // يمكنك تركها كما هي أو مسح البعض
    // day = '';
    // periodLesson = '';
    // hall = '';
    // selectedOverseers.clear();
    // لكن الأفضل تركها لتكرار الإضافة بسرعة
    showsnack(
        title: "تم",
        message: "تم إضافة الدرس إلى القائمة (${lessonsQueue.length})");
  }

  @override
  void removeLessonFromQueue(int index) {
    if (index >= 0 && index < lessonsQueue.length) {
      lessonsQueue.removeAt(index);
      update();
      showsnack(title: "تم", message: "تم حذف الدرس من القائمة");
    }
  }

  @override
  void clearLessonsQueue() {
    lessonsQueue.clear();
    update();
  }

  @override
  void submitLessons() async {
    if (lessonsQueue.isEmpty) {
      showsnack(title: "تنبيه", message: "لا توجد دروس للإضافة");
      return;
    }

    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await adminRemote.addLessons(lessonsQueue);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        showsnack(
            title: "نجاح",
            message: response['message'] ?? "تم إضافة الدروس بنجاح");
        clearLessonsQueue(); // مسح القائمة بعد النجاح
        Get.back(); // العودة للشاشة السابقة
      } else {
        showsnack(title: "خطأ", message: response['message'] ?? "فشل الإضافة");
      }
    } catch (e) {
      showsnack(title: "خطأ", message: "حدث خطأ أثناء الإرسال");
    }
    update();
  }

  // دالة لفتح حوار إضافة درس لخلية محددة (اليوم والفترة محددان)
void showAddLessonDialog(BuildContext context, String day, String period) {
  // نعيد تعيين الحقول المؤقتة (اختياري) لتفادي تداخل القيم السابقة
  selectedCourseId = '';
  selectedOverseers = [];
  hall = '';

  Get.dialog(
    AlertDialog(
      title: Text("إضافة درس في $day - $period"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اختيار المادة
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "المادة"),
                value: selectedCourseId.isEmpty ? null : selectedCourseId,
                items: courses.map((course) {
                  return DropdownMenuItem<String>(
                    value: course.sId,
                    child: Text(course.courseName ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              // اختيار المشرفين (متعدد)
              DropdownSearch<ProfileModel>.multiSelection(
                items: (filter, infiniteScrollProps) {
                  if (overSeers.isEmpty) return [];
                  if (filter.isEmpty) return overSeers.toList();
                  return overSeers.where((overseer) =>
                      overseer.firstName != null &&
                      overseer.firstName!
                          .toLowerCase()
                          .contains(filter.toLowerCase())).toList();
                },
                compareFn: (item1, item2) => item1.user == item2.user,
                onChanged: (List<ProfileModel>? selected) {
                  setState(() {
                    if (selected != null) {
                      selectedOverseers = selected;
                    }
                  });
                },
                selectedItems: selectedOverseers,
                dropdownBuilder: (context, selectedItems) {
                  if (selectedItems.isEmpty) {
                    return Text("اختر المشرفين...", style: TextStyle(color: Colors.grey));
                  }
                  return Text("تم اختيار ${selectedItems.length} مشرف");
                },
                itemAsString: (ProfileModel? p) => "${p!.firstName} ${p.lastName}",
                popupProps: PopupPropsMultiSelection.menu(
                  showSearchBox: true,
                  searchDelay: Duration(milliseconds: 500),
                ),
              ),
              SizedBox(height: 10),
              // اختيار القاعة
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "القاعة"),
                value: hall.isEmpty ? null : hall,
                items: AppConstants.hall.map((h) {
                  return DropdownMenuItem<String>(value: h, child: Text(h));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    hall = value!;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("إلغاء")),
        ElevatedButton(
          onPressed: () {
            // التحقق من اكتمال البيانات
            if (selectedCourseId.isEmpty ||
                selectedOverseers.isEmpty ||
                hall.isEmpty) {
              Get.snackbar("خطأ", "يرجى ملء جميع الحقول");
              return;
            }
            // بناء الدرس وإضافته للقائمة
            Map<String, dynamic> lesson = {
              "course": selectedCourseId,
              "category": selectedCategoryId,
              "overseers": selectedOverseers.map((o) => o.user).toList(),
              "time": "$day-$period",
              "hall": hall,
            };
            // التحقق من عدم وجود درس مكرر في نفس الخلية
            bool exists = lessonsQueue.any((l) => l['time'] == '$day-$period');
            if (exists) {
              Get.snackbar("تنبيه", "يوجد درس مسبق في هذه الخلية، قم بحذفه أولاً");
              return;
            }
            lessonsQueue.add(lesson);
            update();
            Get.back();
            Get.snackbar("تم", "تم إضافة الدرس");
          },
          child: Text("إضافة"),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
Future<void> updateLesson(String id, Map data) async {
  statusRequest = StatusRequest.loading;
  update();
  var response = await adminRemote.updateLesson(id, data);
  statusRequest = handlingData(response);
  if (statusRequest == StatusRequest.success) {
    Get.snackbar("نجاح", response['message'] ?? "تم التعديل بنجاح");
    getSchedule(); // تحديث الجدول
  } else {
    Get.snackbar("خطأ", response['message'] ?? "فشل التعديل");
  }
  update();
}

void showEditLessonDialog(BuildContext context, LessonModel lesson) {
  String tempCourseId = lesson.course?.sId ?? '';
  String tempCategoryId = lesson.category?.sId ?? '';
  List<String> tempOverseerIds = lesson.overseers?.map((o) => o.user ?? '').where((id) => id.isNotEmpty).toList() ?? [];
  String tempHall = lesson.hall ?? '';

  Get.dialog(
    AlertDialog(
      title: Text("تعديل درس في ${lesson.day} - ${lesson.period}"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // المادة
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "المادة"),
                value: tempCourseId.isEmpty ? null : tempCourseId,
                items: courses.map((c) => DropdownMenuItem<String>(
                  value: c.sId,
                  child: Text(c.courseName ?? ""),
                )).toList(),
                onChanged: (val) => setState(() => tempCourseId = val!),
              ),
              const SizedBox(height: 10),
              // الفئة
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "الفئة"),
                value: tempCategoryId.isEmpty ? null : tempCategoryId,
                items: categorys.map((c) => DropdownMenuItem<String>(
                  value: c['id'],
                  child: Text(c['category'] ?? ""),
                )).toList(),
                onChanged: (val) => setState(() => tempCategoryId = val!),
              ),
              const SizedBox(height: 10),
              // المشرفين (متعدد)
              DropdownSearch<ProfileModel>.multiSelection(
                items: (filter, infiniteScrollProps) {
                  if (overSeers.isEmpty) return [];
                  if (filter.isEmpty) return overSeers.toList();
                  return overSeers.where((o) =>
                      o.firstName != null &&
                      o.firstName!.toLowerCase().contains(filter.toLowerCase())).toList();
                },
                compareFn: (item1, item2) => item1.user == item2.user,
                onChanged: (List<ProfileModel>? selected) {
                  setState(() {
                    if (selected != null) {
                      tempOverseerIds = selected.map((o) => o.user ?? '').where((id) => id.isNotEmpty).toList();
                    }
                  });
                },
                selectedItems: overSeers.where((o) => tempOverseerIds.contains(o.user)).toList(),
                dropdownBuilder: (context, selectedItems) {
                  if (selectedItems.isEmpty) return const Text("اختر المشرفين...");
                  return Text("تم اختيار ${selectedItems.length} مشرف");
                },
                itemAsString: (ProfileModel? p) => "${p!.firstName} ${p.lastName}",
                popupProps: PopupPropsMultiSelection.menu(
                  showSearchBox: true,
                  searchDelay: const Duration(milliseconds: 500),
                ),
              ),
              const SizedBox(height: 10),
              // القاعة
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "القاعة"),
                value: tempHall.isEmpty ? null : tempHall,
                items: AppConstants.hall.map((h) => DropdownMenuItem<String>(
                  value: h,
                  child: Text(h),
                )).toList(),
                onChanged: (val) => setState(() => tempHall = val!),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
        ElevatedButton(
          onPressed: () {
            if (tempCourseId.isEmpty || tempOverseerIds.isEmpty || tempHall.isEmpty) {
              Get.snackbar("خطأ", "يرجى ملء جميع الحقول");
              return;
            }
            Map<String, dynamic> data = {
              "course": tempCourseId,
              "category": tempCategoryId,
              "overseers": tempOverseerIds,
              "hall": tempHall,
              // الوقت لا نغيره (يبقى كما هو)
            };
            updateLesson(lesson.sId!, data);
            Get.back();
          },
          child: const Text("تعديل"),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
}
