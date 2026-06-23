import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/admin_home_screen.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/main_screen__admin.dart';
import 'package:gr_flutter/views/patient_views/pages_of_main/main_screen_patient.dart';
import 'package:gr_flutter/views/public_views/settings/unified_profile_screen.dart';
import 'package:gr_flutter/views/public_views/change_password_screen.dart';
import 'package:gr_flutter/views/public_views/contact_support_screen.dart';
import 'package:gr_flutter/views/public_views/privacy_policy_screen.dart';

import 'bindings/feed_binding.dart';
import 'bindings/login_binding.dart';
import 'bindings/main_overseer_binding.dart';
import 'bindings/main_patient_binding.dart';
import 'bindings/main_student_binding.dart';
import 'bindings/register_binding.dart';
import 'bindings/student_requests_binding.dart';
import 'bindings/unified_setting_binding.dart';
import 'views/admin_views/request_and_courses/add_category_page.dart';
import 'views/admin_views/request_and_courses/add_course_page.dart';
import 'views/admin_views/request_and_courses/add_lessons_page.dart';
import 'views/admin_views/request_and_courses/add_treatment_page.dart';
import 'views/admin_views/request_and_courses/view_categorys_page.dart';
import 'views/admin_views/request_and_courses/view_courses_page.dart';
import 'views/admin_views/request_and_courses/view_finished_requests_page.dart';
import 'views/admin_views/request_and_courses/view_in_processing_requests_page.dart';
import 'views/admin_views/request_and_courses/view_pending_requests_page.dart';
import 'views/admin_views/request_and_courses/view_rejected_requests_page.dart';
import 'views/admin_views/request_and_courses/view_treatments_page.dart';
import 'views/admin_views/submit_verify_student.dart';
import 'views/admin_views/users/add_over_seer_page.dart';
import 'views/admin_views/users/view_over_seers_page.dart';
import 'views/admin_views/users/view_patientes_page.dart';
import 'views/admin_views/users/view_students_page.dart';
import 'views/admin_views/users/view_verify_students_page.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/public_views/chat_screen.dart';
import 'views/public_views/conversations_screen.dart';
import 'views/public_views/notifications_view.dart';
import 'views/overseer_views/page_of_main/main_screen_overseer.dart';
import 'views/public_views/posts/create_post_screen.dart';
import 'views/public_views/posts/feed_screen.dart';
import 'views/public_views/posts/post_detail_screen.dart';
import 'views/public_views/settings/unified_edit_profile_screen.dart';
import 'views/public_views/settings/unified_setting_screen.dart';
import 'views/student_views/main_screen_student.dart';
import 'views/student_views/page_of_main/student_home_screen.dart';
import 'views/student_views/page_of_main/student_requests_screen.dart';
import 'views/student_views/page_of_main/show_owned_student_request.dart';
import 'views/student_views/view_verify_page.dart';
import 'views/widgets/ai/chat_gimini.dart';
import 'views/public_views/view_other_profile.dart';



List<GetPage<dynamic>> routes = [




  // ========== AUTH ==========
  GetPage(
    name: "/",
    page: () => RegisterScreen(),
    binding: RegisterBinding()  
  ),
  GetPage( 
    name: AppRroute.login,
    page: () => LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRroute.register,
    page: () => RegisterScreen(),
    binding: RegisterBinding(),
  ),

  // ========== GENERAL ==========
  GetPage(
    name: AppRroute.notificationsView,
    page: () => NotificationsView(),
  ),
  GetPage(
    name: AppRroute.conversations,
    page: () => const ConversationsScreen(),
  ),
  GetPage(
    name: AppRroute.viewOtherProfile,
    page: () => ViewOtherProfile(),
  ),
  GetPage(
    name: AppRroute.aiChat,
    page: () => ChatScreen(),
  ),
  GetPage(
    name: AppRroute.changePassword,
    page: () => ChangePasswordScreen(),
  ),
  GetPage(
    name: AppRroute.privacyPolicy,
    page: () => PrivacyPolicyScreen(),
  ),
  GetPage(
    name: AppRroute.contactSupport,
    page: () => ContactSupportScreen(),
  ),

  // ============================================================================== CHAT (with arguments) ==========
  GetPage(
    name: AppRroute.chat,
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return ChatScreenn(
        otherPartyProfile: args['otherPartyProfile'],
        conversationId: args['conversationId'],
      );
    },
  ),

  // =============================================================== POSTS (Feed) ==========
  GetPage(
    name: AppRroute.feed,
    page: () => FeedScreen(),
    binding: FeedBinding(),
  ),
  GetPage(
    name: AppRroute.createPost,
    page: () => CreatePostScreen(),
  ),
  GetPage(
    name: AppRroute.postDetail,
    page: () => PostDetailScreen(postId: Get.arguments),
  ),

  // ================================================================= UNIFIED SETTINGS & PROFILE ==========
  GetPage(
    name: AppRroute.unifiedSetting,
    page: () => UnifiedSettingScreen(),
    binding: UnifiedSettingBinding(),
  ),
  GetPage(
    name: AppRroute.unifiedProfileScreen,
    page: () => UnifiedProfileScreen(),
  ),
  GetPage(
    name: AppRroute.unifiedEditProfile,
    page: () => UnifiedEditProfileScreen(),
  ),

  // ========================================================================== STUDENT ==========
  GetPage(
    name: AppRroute.mainScreenStudent,
    page: () => MainScreenStudent(),
    binding: MainStudentBinding(),
  ),
  GetPage(
    name: AppRroute.homeScreenStudent,
    page: () => StudentHomeScreen(),
  ),
  GetPage(
    name: AppRroute.studentRequests,
    page: () => StudentRequestsScreen(),
    binding: StudentRequestsBinding(),
  ),
  // GetPage(
  //   name: AppRroute.studentProfileInfoScreen,
  //   page: () => StudentProfileInfoScreen(),
  // ),
  GetPage(
    name: AppRroute.showOwnedStudentRequest,
    page: () => ShowOwnedStudentRequest(),
  ),
  GetPage(
    name: AppRroute.viewVerify,
    page: () => ViewVerifyPage(),
  ),

  // ========== PATIENT ==========
  GetPage(
    name: AppRroute.mainScreenPatient,
    page: () => MainScreenPatient(),
    binding: MainPatientBinding(),
  ),
  GetPage(
    name: AppRroute.homeScreenPatient,
    page: () => Container(), // يمكنك وضع PatientHomeScreen لاحقاً
  ),
  GetPage(
    name: AppRroute.patientPage,
    page: () => Container(),
  ),
  GetPage(
    name: AppRroute.patientShowProfile,
    page: () => Container(),
  ),
  GetPage(
    name: AppRroute.patientUpdateProfile,
    page: () => Container(),
  ),

  // ========== OVERSEER ==========
  GetPage(
    name: AppRroute.mainScreenOverseer,
    page: () => MainScreenOverseer(),
    binding: MainOverseerBinding()
  ),

  // ========== ADMIN ==========
  GetPage(
    name: AppRroute.mainScreenAdmin,
    page: () => MainScreenAdmin(),
  ),
  GetPage(
    name: AppRroute.adminHomeScreen,
    page: () => AdminHomeScreen(),
  ),
  GetPage(
    name: AppRroute.addOverSeer,
    page: () => AddOverSeerPage(),
  ),
  GetPage(
    name: AppRroute.viewOverSeers,
    page: () => ViewOverSeersPage(),
  ),
  GetPage(
    name: AppRroute.viewStudents,
    page: () => ViewStudentsPage(),
  ),
  GetPage(
    name: AppRroute.viewPatientes,
    page: () => ViewPatientesPage(),
  ),
  GetPage(
    name: AppRroute.verifyStudents,
    page: () => ViewVerifyStudentsPage(),
  ),
  GetPage(
    name: AppRroute.submitVerifyStudent,
    page: () => SubmitVerifyStudent(studentModel: Get.arguments),
  ),
  GetPage(
    name: AppRroute.addCourse,
    page: () => AddCoursePage(),
  ),
  GetPage(
    name: AppRroute.addTreatment,
    page: () => AddTreatmentPage(),
  ),
  GetPage(
    name: AppRroute.addLessons,
    page: () => AddLessonsPage(),
  ),
  GetPage(
    name: AppRroute.addCategory,
    page: () => AddCategoryPage(),
  ),
  GetPage(
    name: AppRroute.viewCourses,
    page: () => ViewCoursesPage(),
  ),
  GetPage(
    name: AppRroute.viewTreatments,
    page: () => ViewTreatmentsPage(),
  ),
  GetPage(
    name: AppRroute.viewCategorys,
    page: () => ViewCategorysPage(),
  ),
  GetPage(
    name: AppRroute.viewPendingRequests,
    page: () => ViewPendingRequestsPage(),
  ),
  GetPage(
    name: AppRroute.viewInProcessingRequests,
    page: () => ViewInProcessingRequestsPage(),
  ),
  GetPage(
    name: AppRroute.viewFinishedRequests,
    page: () => ViewFinishedRequestsPage(),
  ),
  GetPage(
    name: AppRroute.viewRejectedRequests,
    page: () => ViewRejectedRequestsPage(),
  ),
];

class AppRroute {
  // ========== AUTH ==========
  static const String login = "/login";
  static const String register = "/register";

  // ========== GENERAL ==========
  static const String homeScreenAll = "/homeScreenAll";
  static const String notificationsView = "/notifications";
  static const String chat = "/chat";
  static const String conversations = "/conversations";
  static const String viewOtherProfile = "/viewOtherProfile";
  static const String aiChat = "/aiChat";
  static const String changePassword = "/change_password";
  static const String privacyPolicy = "/privacy_policy";
  static const String contactSupport = "/contact_support";

  // ========== POSTS ==========
  static const String feed = "/feed";
  static const String createPost = "/create_post";
  static const String postDetail = "/post_detail";

  // ========== UNIFIED ==========
  static const String unifiedSetting = "/unified_setting";
  static const String unifiedProfileScreen = "/unifiedProfileScreen";
  static const String unifiedEditProfile = "/unified_edit_profile";

  // ========== STUDENT ==========
  static const String mainScreenStudent = "/mainScreenStudent";
  static const String homeScreenStudent = "/homeScreenStudent";
  static const String studentRequests = "/studentRequests";
  static const String studentProfileInfoScreen = "/studentProfileInfoScreen";
  static const String showOwnedStudentRequest = "/showOwnedStudentRequest";
  static const String viewVerify = "/viewVerify";

  // ========== PATIENT ==========
  static const String mainScreenPatient = "/mainScreenPatient";
  static const String homeScreenPatient = "/homeScreenPatient";
  static const String patientPage = "/patientPage";
  static const String patientShowProfile = "/patientShowProfile";
  static const String patientUpdateProfile = "/patientUpdateProfile";

  // ========== OVERSEER ==========
  static const String mainScreenOverseer = "/mainScreenOverseer";

  // ========== ADMIN ==========
  static const String mainScreenAdmin = "/mainScreenAdmin";
  static const String adminHomeScreen = "/adminHomeScreen";
  static const String addOverSeer = "/addOverSeer";
  static const String viewOverSeers = "/viewOverSeers";
  static const String viewStudents = "/viewStudents";
  static const String viewPatientes = "/viewPatientes";
  static const String verifyStudents = "/verifyStudents";
  static const String submitVerifyStudent = "/submitVerifyStudent";
  static const String addCourse = "/addCourse";
  static const String addTreatment = "/addTreatment";
  static const String addLessons = "/addLessons";
  static const String addCategory = "/addCategory";
  static const String viewCourses = "/viewCourses";
  static const String viewTreatments = "/viewTreatments";
  static const String viewCategorys = "/viewCategorys";
  static const String viewPendingRequests = "/viewPendingRequests";
  static const String viewInProcessingRequests = "/viewInProcessingRequests";
  static const String viewFinishedRequests = "/viewFinishedRequests";
  static const String viewRejectedRequests = "/viewRejectedRequests";

  // ========== LEGACY (keep if needed) ==========
  static const String home = "/home";
  static const String homeScreen = "/homeScreen";
  static const String notifications = "/notifications";
  static const String profile = "/profile";
  static const String gptProfile = "/gptProfile";
}