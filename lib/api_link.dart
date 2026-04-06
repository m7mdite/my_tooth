class ApiLink {
  static const String servere = 'http://localhost:5000/api';



  // ========================auth
  static const String login = '$servere/auth/login';
  static const String register = '$servere/auth/register';
  // ===========================all user
  static const String profile = '$servere/profile';
  static const String photo = '$servere/users/photo';
  // =========================== patient
  static const String myRequests = '$servere/request/my';

  // =========================== student
  static const String acceptRequest = '$servere/request/accept';
  static const String ownedStudentRequest = '$servere/request/myProcessing';
  static const String verify = '$servere/auth/verify';
  // =========================== admin
  static const String addOverSeer = '$servere/admin/overseer';
  static const String getAllOverSeers = '$servere/admin/overseers';
  static const String getAllStudents = '$servere/admin/students';
  static const String getAllPatientes = '$servere/admin/patients';
  static const String getAllRequests = '$servere/admin/requests';
  static const String getAllVerifyStudents = '$servere/admin/verify';
  static const String acceptVerifyStudent = '$servere/admin/verification/accept';
  static const String addCourse = '$servere/admin/course';
  static const String addTreatment = '$servere/admin/treatment';
  static const String getAllCourses = '$servere/admin/course';
  static const String getAllTreatments = '$servere/admin/treatment';
  // =========================== super
  static const String requests = '$servere/request';
  
}