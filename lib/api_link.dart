class ApiLink {
  static const String servere = 'http://localhost:5000/api';

  // ========================auth
  static const String login = '$servere/auth/login';
  static const String register = '$servere/auth/register';
  static const String logout = "$servere/auth/logout";
  // ===========================all user
  static const String profile = '$servere/profile';
  static const String photo = '$servere/users/photo';
  static const String conversations = '$servere/conversations';
  static const String getOtherProfile = '$servere/users';
  static const String reportUser = '$servere/reports';
  static const String supportMessage = "$servere/support";
  static const String requests = '$servere/request';
  static const String posts = "$servere/posts";
static const String comments = "$servere/posts/comments";
  static const String changePassword =
      "$servere/auth/change-password"; 
  static const String dashboard =
      "$servere/dashboard"; 

  // =========================== patient
  static const String pendingPatientRequest = '$servere/request/my';
  static const String inProcessingPatientRequest =
      '$servere/request/processing';
  static const String completedPatientRequest = '$servere/request/finished';
  static const String rejectedPatientRequest = '$servere/request/rejected';
  static const String treatments = '$servere/admin/treatment';
  // =========================== student
  static const String acceptRequest = '$servere/request/accept';
  static const String dunningOverseer = '$servere/request/reassign-overseer';
  static const String ownedStudentRequest = '$servere/request/processing';
  static const String verify = '$servere/auth/verify';
  static const String getOverSeerForCourse =
      '$servere/request/course-overseers';

  // =========================== super

  // ================================================= overseer
  static const String treatmentRequestsForOverseer =
      '$servere/overseer/treatment';
  static const String rejectRequest = '$servere/overseer/treatment/reject';
  static const String changeCaseRequest = '$servere/overseer/treatment/reject';
  static const String complateRequest = '$servere/overseer/treatment/complete';
  static const String addEvaluationRequest = '$servere/overseer/add-evaluation';

  // =========================== admin
  static const String addOverSeer = '$servere/admin/overseer';
  static const String getAllOverSeers = '$servere/admin/overseers';
  static const String getAllStudents = '$servere/admin/students';
  static const String getAllPatientes = '$servere/admin/patients';
  static const String getAllRequests = '$servere/admin/requests';
  static const String getAllVerifyStudents = '$servere/admin/verify';
  static const String acceptVerifyStudent =
      '$servere/admin/verify/accept';
  static const String rejectVerifyStudent =
      '$servere/admin/verify/reject';
  static const String addCourse = '$servere/admin/course';
  static const String addTreatment = '$servere/admin/treatment';
  static const String addCategory = '$servere/admin/category';
  static const String weeklySchedule = '$servere/admin/practical-lessons';
  static const String getAllCourses = '$servere/admin/course';
  static const String getAllTreatments = '$servere/admin/treatment';
  static const String getAllCategory = '$servere/admin/category';
  static const String getAllPendingRequests = '$servere/request';
  static const String getAllInProcessingRequests =
      '$servere/request/Processing';
  static const String getAllFinishedRequests = '$servere/request/finished';
  static const String getAllRejectedRequests = '$servere/request/rejected';
  static const String advertisements = '$servere/advertisements';
  static const String adminReports = "$servere/reports";
  static String reviewReport(String id) => "$servere/reports/$id";
  static const String deleteOverSeer = "$servere/admin/overseer/delete";
  static const String categories = "$servere/admin/categories";

}
