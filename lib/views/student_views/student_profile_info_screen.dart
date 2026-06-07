// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/student_controller/student_setting_controller.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:gr_flutter/views/widgets/default_container_profile.dart';

// class StudentProfileInfoScreen extends StatelessWidget {
//   final StudentSettingControllerImp controller =
//       Get.find<StudentSettingControllerImp>(); // أو Get.put

//   StudentProfileInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: RefreshIndicator(
//         onRefresh: () async {},
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(AppConstants.defaultBackgroundImage),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.linearToSrgbGamma(),
//             ),
//           ),
//           child: ListView(
//             children: [
//               // صورة المستخدم الدائرية (مؤقتة)
//               Center(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 30),
//                   padding: EdgeInsets.all(5),
//                   height: Get.width * 0.5,
//                   width: Get.width * 0.5,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(color: Colors.blue, blurRadius: 20, spreadRadius: 1)
//                     ],
//                     borderRadius: BorderRadius.circular(100),
//                     image: DecorationImage(
//                       image: AssetImage(AppConstants.defaultBackgroundImage),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(color: Colors.white, strokeAlign: 5, width: 2),
//                   ),
//                 ),
//               ),
//               // الاسم الكامل مع أيقونة التوثيق
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     controller.authService.getFullName(),
//                     style: TextStyle(color: Colors.black, fontSize: 18),
//                   ),
//                   if (controller.authService.isVerified() == true)
//                     Icon(Icons.star_rounded, color: Colors.blue, size: 22),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // البريد الإلكتروني
//               Center(
//                 child: DefaultContainerProfile(
//                   color: Colors.blue,
//                   title: controller.authService.getEmail() ?? "بريد إلكتروني غير مضاف",
//                   icon: Icons.email_outlined,
//                   onTap: null, // غير قابل للنقر
//                 ),
//               ),
//               SizedBox(height: 20),
//               // الدور (طالب/مريض/مشرف)
//               Center(
//                 child: DefaultContainerProfile(
//                   color: Colors.blue,
//                   title: "الدور: ${controller.authService.getRole() ?? 'غير محدد'}",
//                   icon: Icons.badge_outlined,
//                   onTap: null,
//                 ),
//               ),
//               // معلومات إضافية حسب الدور (إذا كان controller يمتلكها)
//               if (controller.authService.getRole() == "student") ...[
//                 SizedBox(height: 20),
//                 Center(
//                   child: DefaultContainerProfile(
//                     color: Colors.blue,
//                     // title: "السنة: ${controller.authService.getYear() ?? 'غير محدد'}",
//                     icon: Icons.school_outlined,
//                     onTap: null,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: DefaultContainerProfile(
//                     color: Colors.blue,
//                     // title: "الفئة: ${controller.authService.getCategory() ?? 'غير محدد'}",
//                     icon: Icons.group_outlined,
//                     onTap: null,
//                   ),
//                 ),
//               ],
//               if (controller.authService.getRole() == "patient") ...[
//                 SizedBox(height: 20),
//                 Center(
//                   child: DefaultContainerProfile(
//                     color: Colors.blue,
//                     title: "العمر: ${controller.authService.getAge() ?? 'غير محدد'}",
//                     icon: Icons.cake_outlined,
//                     onTap: null,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: DefaultContainerProfile(
//                     color: Colors.blue,
//                     title: "الجنس: ${controller.authService.getGender() ?? 'غير محدد'}",
//                     icon: Icons.sports_gymnastics_outlined,
//                     onTap: null,
//                   ),
//                 ),
//               ],
//               // السيرة الذاتية (bio)
//               if (controller.authService.getBio() != null &&
//                   controller.authService.getBio()!.isNotEmpty) ...[
//                 SizedBox(height: 20),
//                 Center(
//                   child: DefaultContainerProfile(
//                     color: Colors.blue,
//                     title: controller.authService.getBio()!,
//                     icon: Icons.description_outlined,
//                     onTap: null,
//                   ),
//                 ),
//               ],
//               SizedBox(height: 30),
//               // زر تعديل الملف الشخصي (يؤدي إلى شاشة التعديل)
//               Center(
//                 child: DefaultContainerProfile(
//                   color: Colors.blue,
//                   title: "تعديل الملف الشخصي",
//                   icon: Icons.edit_outlined,
//                   onTap: () {
//                     controller.toProfileInfo(); // نفس دالة تعديل المعلومات
//                   },
//                 ),
//               ),
//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }