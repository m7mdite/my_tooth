// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/patient_controller/patient_setting_controller.dart';
// import '../../utils/app_constants/status_request.dart';

// class PatientUpdateProfile extends StatelessWidget {
//   final PatientSettingControllerImp controller = Get.find();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
//   // Text editing controllers
//   late TextEditingController firstNameController;
//   late TextEditingController fatherNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController ageController;
//   late TextEditingController genderController;
  
//   PatientUpdateProfile({super.key}) {
//     // تهيئة المتحكمات بالقيم الحالية
//     firstNameController = TextEditingController(text: controller.getFirstName());
//     fatherNameController = TextEditingController(text: controller.getFatherName());
//     lastNameController = TextEditingController(text: controller.getLastName());
//     emailController = TextEditingController(text: controller.getEmail());
//     phoneController = TextEditingController(text: controller.getPhoneNumber());
//     ageController = TextEditingController(text: controller.getAge());
//     genderController = TextEditingController(text: controller.getGender());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'تعديل الملف الشخصي',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.blue,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // زر العودة
//             Positioned(
//               top: 10,
//               left: 10,
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
//                 onPressed: () => Get.back(),
//               ),
//             ),
            
//             SingleChildScrollView(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20),
                    
//                     // عنوان الصفحة
//                     Center(
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.edit_outlined,
//                             size: 60,
//                             color: Colors.blue,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'تحديث المعلومات الشخصية',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue.shade800,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             'قم بتعديل البيانات التي ترغب في تحديثها',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                    
//                     SizedBox(height: 40),
                    
//                     // الاسم الأول
//                     _buildInputField(
//                       controller: firstNameController,
//                       label: 'الاسم الأول',
//                       icon: Icons.person_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال الاسم الأول';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // اسم الأب
//                     _buildInputField(
//                       controller: fatherNameController,
//                       label: 'اسم الأب',
//                       icon: Icons.person_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال اسم الأب';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // الاسم الأخير
//                     _buildInputField(
//                       controller: lastNameController,
//                       label: 'الاسم الأخير',
//                       icon: Icons.person_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال الاسم الأخير';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // البريد الإلكتروني
//                     _buildInputField(
//                       controller: emailController,
//                       label: 'البريد الإلكتروني',
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال البريد الإلكتروني';
//                         }
//                         if (!GetUtils.isEmail(value)) {
//                           return 'الرجاء إدخال بريد إلكتروني صحيح';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // رقم الجوال
//                     _buildInputField(
//                       controller: phoneController,
//                       label: 'رقم الجوال',
//                       icon: Icons.phone_android_outlined,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال رقم الجوال';
//                         }
//                         if (value.length < 10) {
//                           return 'رقم الجوال يجب أن يكون 10 أرقام على الأقل';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // العمر
//                     _buildInputField(
//                       controller: ageController,
//                       label: 'العمر',
//                       icon: Icons.cake_outlined,
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال العمر';
//                         }
//                         if (int.tryParse(value) == null) {
//                           return 'الرجاء إدخال رقم صحيح';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // الجنس
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         value: genderController.text.isEmpty ? null : genderController.text,
//                         decoration: InputDecoration(
//                           labelText: 'الجنس',
//                           labelStyle: TextStyle(color: Colors.blue.shade700),
//                           prefixIcon: Icon(Icons.transgender_outlined, color: Colors.blue),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(color: Colors.blue, width: 2),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                         ),
//                         items: [
//                           DropdownMenuItem(value: 'male', child: Text('ذكر')),
//                           DropdownMenuItem(value: 'female', child: Text('أنثى')),
//                         ],
//                         onChanged: (value) {
//                           genderController.text = value ?? '';
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'الرجاء اختيار الجنس';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
                    
//                     SizedBox(height: 40),
                    
//                     // زر الحفظ - استخدام GetBuilder بدلاً من Obx
//                     GetBuilder<PatientSettingControllerImp>(
//                       builder: (controller) {
//                         return Container(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             onPressed: controller.statusRequest == StatusRequest.loading
//                                 ? null
//                                 : () => _saveChanges(),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               elevation: 5,
//                             ),
//                             child: controller.statusRequest == StatusRequest.loading
//                                 ? SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : Text(
//                                     'حفظ التغييرات',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                           ),
//                         );
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // زر إلغاء
//                     Container(
//                       width: double.infinity,
//                       height: 55,
//                       child: OutlinedButton(
//                         onPressed: () => Get.back(),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.blue,
//                           side: BorderSide(color: Colors.blue),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: Text(
//                           'إلغاء',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         textAlign: TextAlign.right,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.blue.shade700),
//           prefixIcon: Icon(icon, color: Colors.blue),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.blue, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         ),
//         validator: validator,
//       ),
//     );
//   }
  
//   void _saveChanges() async {
//     if (_formKey.currentState!.validate()) {
//       // تجهيز البيانات للتحديث
//       Map<String, dynamic> updatedData = {
//         'first_name': firstNameController.text,
//         'father_name': fatherNameController.text,
//         'last_name': lastNameController.text,
//         'email': emailController.text,
//         'phone_number': phoneController.text,
//         'age': int.tryParse(ageController.text),
//         // 'gender': genderController.text,
//       };
      
//       // استدعاء دالة التحديث في الكونترولر
//       await controller.updateProfileData(updatedData);
//     }
//   }
  
//   void dispose() {
//     // تنظيف المتحكمات عند إغلاق الصفحة
//     firstNameController.dispose();
//     fatherNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     ageController.dispose();
//     genderController.dispose();
//     // super.dispose();
//   }
// }