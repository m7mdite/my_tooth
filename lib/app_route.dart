import 'package:get/get.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/admin_home_screen.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/main_screen__admin.dart';
import 'package:gr_flutter/views/patient_views/pages_of_main/main_screen_patient.dart';

import 'models/conversation_model.dart';
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
import 'views/auth/login.dart';
import 'views/auth/register.dart';
import 'views/chat_screen.dart';
import 'views/conversations_screen.dart';
import 'views/notifications_view.dart';
import 'views/overseer_views/page_of_main/main_screen_overseer.dart';
import 'views/patient_views/patient_show_profile.dart';
import 'views/patient_views/patient_update_profile.dart';
import 'views/posts/create_post_screen.dart';
import 'views/posts/feed_screen.dart';
import 'views/posts/post_detail_screen.dart';
import 'views/student_views/main_screen_student.dart';
import 'views/student_views/page_of_main/student_home_screen.dart';
import 'views/student_views/show_owned_student_request.dart';
import 'views/student_views/student_profile_info_screen.dart';
import 'views/student_views/view_verify_page.dart';
import 'views/widgets/ai/chat_gimini.dart';
import 'views/widgets/view_other_profile.dart';

List<GetPage<dynamic>>? routes = [
  // GetPage(
  //     name: "/", page: () => const Register(), middlewares: [MyMiddleWere()]),
  GetPage(name: "/", page: () => Register()),

  // GetPage(
  // name: AppRroute.homeScreen,
  // page: () => HomeScreen()),
  // all
  // GetPage(name: AppRroute.homeScreenAll, page: () => HomeScreen()),
  GetPage(name: AppRroute.feed, page: () => FeedScreen()),
GetPage(name: AppRroute.createPost, page: () => CreatePostScreen()),
GetPage(name: AppRroute.postDetail, page: () => PostDetailScreen(postId: Get.arguments)),
  GetPage(name: AppRroute.notificationsView, page: () => NotificationsView()),
  // admin
  GetPage(name: AppRroute.mainScreenAdmin, page: () => MainScreenAdmin()),
  GetPage(name: AppRroute.adminHomeScreen, page: () => AdminHomeScreen()),
  GetPage(name: AppRroute.addOverSeer, page: () => AddOverSeerPage()),
  GetPage(name: AppRroute.viewOverSeers, page: () => ViewOverSeersPage()),
  GetPage(name: AppRroute.viewStudents, page: () => ViewStudentsPage()),
  GetPage(name: AppRroute.viewPatientes, page: () => ViewPatientesPage()),
  GetPage(name: AppRroute.verifyStudents, page: () => ViewVerifyStudentsPage()),
  GetPage(
      name: AppRroute.submitVerifyStudent,
      page: () => SubmitVerifyStudent(studentModel: Get.arguments)),
  GetPage(name: AppRroute.addCourse, page: () => AddCoursePage()),
  GetPage(name: AppRroute.addTreatment, page: () => AddTreatmentPage()),
  GetPage(name: AppRroute.addLessons, page: () => AddLessonsPage()),
  GetPage(name: AppRroute.addCategory, page: () => AddCategoryPage()),
  GetPage(name: AppRroute.viewCourses, page: () => ViewCoursesPage()),
  GetPage(name: AppRroute.viewTreatments, page: () => ViewTreatmentsPage()),
  GetPage(name: AppRroute.viewCategorys, page: () => ViewCategorysPage()),
  GetPage(
      name: AppRroute.viewPendingRequests,
      page: () => ViewPendingRequestsPage()),
  GetPage(
      name: AppRroute.viewInProcessingRequests,
      page: () => ViewInProcessingRequestsPage()),
  GetPage(
      name: AppRroute.viewFinishedRequests,
      page: () => ViewFinishedRequestsPage()),
  GetPage(
      name: AppRroute.viewRejectedRequests,
      page: () => ViewRejectedRequestsPage()),

  // student
  GetPage(name: AppRroute.mainScreenStudent, page: () => MainScreenStudent()),
  GetPage(name: AppRroute.homeScreenStudent, page: () => StudentHomeScreen()),
  GetPage(
      name: AppRroute.studentProfileInfoScreen,
      page: () => StudentProfileInfoScreen()),
  GetPage(
      name: AppRroute.showOwnedStudentRequest,
      page: () => ShowOwnedStudentRequest()),
  GetPage(name: AppRroute.viewVerify, page: () => ViewVerifyPage()),
  // patient
  GetPage(name: AppRroute.mainScreenPatient, page: () => MainScreenPatient()),
  GetPage(name: AppRroute.patientShowProfile, page: () => PatientShowProfile()),
  GetPage(
      name: AppRroute.patientUpdateProfile, page: () => PatientUpdateProfile()),
  GetPage(name: AppRroute.aiChat, page: () => ChatScreen()),
  // overseer
  GetPage(name: AppRroute.mainScreenOverseer, page: () => MainScreenOverseer()),
  // //
  GetPage(name: AppRroute.login, page: () => Login()),
  GetPage(name: AppRroute.register, page: () => Register()),
  // GetPage(name: AppRroute.patientPage, page: () => PatientPage()),

  //        admin
  //        patient
  //        student

  // //
  // GetPage(name: AppRroute.homeScreen, page: () =>  HomeScreen()),
  // GetPage(name: AppRroute.chat, page: () =>  Chat()),
  // GetPage(name: AppRroute.notifications, page: () =>  Notifications()),
  // GetPage(name: AppRroute.profile, page: () =>  Profile()),
  // GetPage(name: AppRroute.gptProfile, page: () =>  GptProfile()),
  GetPage(
      name: AppRroute.conversations, page: () => const ConversationsScreen()),
  GetPage(name: AppRroute.viewOtherProfile, page: () => ViewOtherProfile()),
  GetPage(
      name: AppRroute.chat,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ChatScreenn(
          otherProfilePhotoUrl:
              (args['otherParty'] as OtherPartyModel).profilePhoto?['url'],
          otherUserId: (args['otherParty'] as OtherPartyModel).userId,
          conversationId: args['conversationId'],
          otherPartyName: (args['otherParty'] as OtherPartyModel).fullName,
        );
      }),
];

class AppRroute {
  // home
  static const String home = "/home";
  // auth
  static const String login = "/login";
  static const String register = "/register";

// all
  static const String homeScreenAll = "/homeScreenAll";
  static const String notificationsView = "/notifications";
  static const String chat = "/chat";
  static const String conversations = "/conversations";
  static const String viewOtherProfile = "/viewOtherProfile";
  static const String feed = '/feed';
static const String createPost = '/create_post';
static const String postDetail = '/post_detail';


  // admin
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
  // student
  static const String mainScreenStudent = "/mainScreenStudent";
  static const String homeScreenStudent = "/homeScreenStudent";
  static const String studentProfileInfoScreen = "/studentProfileInfoScreen";
  static const String showOwnedStudentRequest = "/showOwnedStudentRequest";
  static const String viewVerify = "/viewVerify";

  // patient
  static const String mainScreenPatient = "/mainScreenPatient";
  static const String homeScreenPatient = "/homeScreenPatient";
  static const String patientPage = "/patientPage";
  static const String patientShowProfile = "/patientShowProfile";
  static const String patientUpdateProfile = "/patientUpdateProfile";
  static const String aiChat = "/aiChat";

  // overseer
  static const String mainScreenOverseer = "/mainScreenOverseer";

  // home screen
  static const String homeScreen = "/homeScreen";
  // static const String chat = "/chat";
  static const String notifications = "/notifications";
  static const String profile = "/profile";
  static const String gptProfile = "/gptProfile";
}
