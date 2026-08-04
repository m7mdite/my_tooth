// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/auth_controllers/register_controller.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
// import 'package:gr_flutter/views/widgets/select_one_option.dart';

// import '../widgets/auth_text_form_field.dart';

// class RegisterScreen extends GetView<RegisterControllerImp> {
//   // final RegisterControllerImp controller = Get.find<RegisterControllerImp>();
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // String? studentId;

//     return Scaffold(
//       backgroundColor: AppColors.primaryAccent,
//       body: Container(
//         height: double.maxFinite,
//         width: double.maxFinite,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("images/images_asnan/asnan6.jpeg"),
//                 fit: BoxFit.cover)),
//         child: Container(
//           margin: EdgeInsets.symmetric(
//               horizontal: Get.width <= 400 ? 15 : (Get.width - 400) * 0.5,
//               vertical: 30),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: AppColors.white,
//               width: 1.5,
//             ),
//             borderRadius: AppThemeConstants.borderRadius,
//             color: const Color.fromARGB(144, 255, 255, 255),
//           ),
//           child: GetBuilder<RegisterControllerImp>(builder: (controller) {
//             return Form(
//               key: controller.formStateRegister,
//               child: ListView(
//                 padding:  const EdgeInsets.symmetric(horizontal: 10),
//                 children: [
//                   SizedBox(height: 20),
//                   Center(
//                     child: Container(
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image:
//                                 AssetImage("images/images_asnan/asnan6.jpeg"),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.circular(300)),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Text(
//                       "إنشاء حساب",
//                       style: TextStyle(
//                           fontSize: 20,
//                           letterSpacing: 1,
//                           fontStyle: FontStyle.normal),
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // الاسم الأول والكنية
//                   Row(
//                     children: [
//                       Expanded(
//                         child: AuthTextFormField(
//                           label: "الاسم",
//                           textEditingController: controller.firstName,
//                         ),
//                       ),
//                       Expanded(
//                         child: AuthTextFormField(
//                           label: "اسم الأب",
//                           textEditingController: controller.fatherName,
//                         ),
//                       ),
//                       Expanded(
//                         child: AuthTextFormField(
//                           label: "الكنية",
//                           textEditingController: controller.lastName,
//                         ),
//                       ),
//                     ],
//                   ),

//                   // الإيميل
//                   AuthTextFormField(
//                     label: "الايميل",
//                     textEditingController: controller.email,
//                   ),

//                   // كلمة المرور
//                   AuthTextFormField(
//                     label: "كلمة المرور",
//                     textEditingController: controller.password,
//                     isPassword: true,
//                   ),

//                   // تأكيد كلمة المرور
//                   AuthTextFormField(
//                     validator: (p0) {
//                       if (p0 != controller.password.text) {
//                         return "غير متطابقة";
//                       } else {
//                         return null;
//                       }
//                     },
//                     label: "تأكيد كلمة المرور",
//                     onChanged: (val) {
//                       controller.validatConfirmPassowrd(val);
//                     },
//                     suffix: controller.confirmPass
//                         ? Icon(
//                             Icons.check_circle_outline,
//                             color: AppColors.primary,
//                           )
//                         : null,
//                     textEditingController: controller.confirmPassword,
//                     isPassword: true,
//                   ),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Spacer(),
//                         Text("الجنس"),
//                         Spacer(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SelectOneOption(
//                               onTap: () {
//                                 controller.gender = "female";
//                                 controller.update();
//                               },
//                               selectOption: controller.gender == "female",
//                               title: "انثى",
//                             ),
//                             SelectOneOption(
//                               onTap: () {
//                                 controller.gender = "male";
//                                 controller.update();
//                               },
//                               selectOption: controller.gender == "male",
//                               title: "ذكر",
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 5,horizontal: Get.width*0.2),
//                     height: 1.0,
//                     width: Get.width*0.8,
//                     color: AppColors.white,
//                   ),
//                   // اختيار الدور
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text("تسجيل كـ "),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SelectOneOption(
//                               onTap: () {
//                                 controller.role = "student";
//                                 controller.update();
//                               },
//                               selectOption: controller.role == "student",
//                               title: "طالب",
//                             ),
//                             SelectOneOption(
//                               onTap: () {
//                                 controller.role = "patient";
//                                 controller.update();
//                               },
//                               selectOption: controller.role == "patient",
//                               title: "مريض",
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // الرقم الجامعي (يظهر فقط إذا كان المستخدم طالب)

//                   if (controller.role == 'student')
//                     AuthTextFormField(
//                       label: "الرقم الجامعي",
//                       textEditingController: controller.universityNumber,
//                     ),

//                   // زر التسجيل
//                   SizedBox(height: 20),
//                   Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return ElevatedButton(
//               onPressed: controller.register,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 "إنشاء حساب",
//                 style: TextStyle(fontSize: 18, color: AppColors.white),
//               ),
//             );
//           }),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Text("هل لديك حساب ؟ "),
//                       TextButton(
//                           onPressed: () {
//                             controller.goToLogin();
//                           },
//                           child: Text("تسجيل الدخول"))
//                     ],
//                   )
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
