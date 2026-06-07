// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../controllers/patient_controller/patient_setting_controller.dart';
// import '../../widgets/change_password_screen.dart';
// import '../../widgets/default_container_profile.dart';

// class PatientSettingScreen extends StatelessWidget {
//   final PatientSettingControllerImp controller =
//       Get.put(PatientSettingControllerImp());
//   PatientSettingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(
//               AppConstants.defaultBackgroundImage,
//             ),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.linearToSrgbGamma()),
//       ),
//       child: GetBuilder<PatientSettingControllerImp>(builder: (_) {
//         return ListView(
//           children: [
//             Center(
//               child: InkWell(
//                 onLongPress: () async {
//                   File? image;
//                   final pickedFile = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     image = File(pickedFile.path);
//                     await controller.uploadProfilePicture(image);
//                   }
//                 },
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 30),
//                   padding: EdgeInsets.all(5),
//                   height: Get.width * 0.5,
//                   width: Get.width * 0.5,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.blue, blurRadius: 20, spreadRadius: 1)
//                     ],
//                     borderRadius: BorderRadius.circular(100),
//                     image: DecorationImage(
//                       image: controller.profilePicture == ""
//                           ? AssetImage(AppConstants.defaultBackgroundImage)
//                           : NetworkImage(
//                               "http://localhost:5000${controller.profilePicture}",
//                             ),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: Colors.white,
//                       strokeAlign: 5,
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   controller.fullName,
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Icon(
//                   Icons.star_half_rounded,
//                   color: Colors.blue,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: DefaultContainerProfile(
//                 color: Colors.blue,
//                 title: "المعلومات الشخصية ",
//                 icon: Icons.person_2_sharp,
//                 onTap: () {
//                   controller.toShowProfile();
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: DefaultContainerProfile(
//                 color: Colors.blue,
//                 title: " تغيير اللغة  ",
//                 icon: Icons.language_rounded,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: DefaultContainerProfile(
//                 color: Colors.blue,
//                 title: " سياسة الخصوصية ",
//                 icon: Icons.privacy_tip_outlined,
//                 onTap: () {},
//               ),
//             ),
//             SizedBox(height: 30),
//             Center(
//               child: DefaultContainerProfile(
//                 color: Colors.blue,
//                 title: " تغيير كلمة المرور ",
//                 icon: Icons.lock_outline,
//                 onTap: () {
//                   Get.to(() => ChangePasswordScreen());
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: DefaultContainerProfile(
//                 color: Colors.blue,
//                 title: " مراسلة الدعم ",
//                 icon: Icons.support_agent_outlined,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: DefaultContainerProfile(
//                 onTap: () {
//                   controller.confirmLogOut();
//                 },
//                 color: Colors.blue,
//                 title: " تسجيل الخروج ",
//                 icon: Icons.logout_outlined,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Container(),
//           ],
//         );
//       }),
//     );
//   }
// }
