// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
// import 'package:gr_flutter/views/widgets/backgound_container_dialog.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../controllers/patient_controller/submitting_request_patient_controller.dart';
// import '../widgets/bottom_controller.dart';
// import '../widgets/container_text_form_field.dart';

// class PatientSubmittingRequestScreen extends StatelessWidget {
//   final SubmittingRequestPatientControllerImp controller =
//       Get.put(SubmittingRequestPatientControllerImp());
//   PatientSubmittingRequestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         bottomNavigationBar: _buildBottomNavigationBar(),
//         body: _buildBody(),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       decoration: BoxDecoration(
//         // color: Colors.black.withOpacity(0.7),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildBottomButton(
//             text: "تأكيد",
//             onTap: controller.submitRequest,
//             backgroundColor: Colors.green,
//           ),
//           _buildBottomButton(
//             text: "إلغاء",
//             onTap: controller.cancelRequest,
//             backgroundColor: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButton({
//     required String text,
//     required VoidCallback onTap,
//     required Color backgroundColor,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         height: 45,
//         width: 120,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return GetBuilder<SubmittingRequestPatientControllerImp>(
//       builder: (controller) {
//         return Form(
//           key: controller.formState,
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildTreatmentTypeSection(controller),
//               const SizedBox(height: 5),
//               _buildPainLevelSection(controller),
//               const SizedBox(height: 5),
//               _buildAgeSection(controller),
//               const SizedBox(height: 8),
//               _buildMoreDetailsSection(controller),
//               const SizedBox(height: 8),
//               _buildGenderSection(controller),
//               const SizedBox(height: 8),
//               _buildToothPositionSection(controller),
//               const SizedBox(height: 8),
//               _buildAttachmentSection(controller),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTreatmentTypeSection(
//       SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "نوع المعالجة",
//       children: [
//         const SizedBox(height: 0),
//         DropdownButtonFormField<String>(
//           value: controller.caseType,
//           items: ToothConstants.caseTypeAr
//               .map((String value) => DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ))
//               .toList(),
//           onChanged: controller.updateCaseType,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'اختر نوع المعالجة',
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           icon: const Icon(Icons.arrow_drop_down),
//           style: const TextStyle(color: Colors.black87),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'الرجاء اختيار نوع المعالجة';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 10),
//         Text(
//           "تم اختيار: ${controller.caseType ?? 'لم يتم الاختيار'}",
//           style: TextStyle(
//             color: controller.caseType != null
//                 ? Colors.green.shade700
//                 : Colors.grey.shade600,
//             fontSize: 12,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPainLevelSection(
//       SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "حدد شدة الألم من 5 ",
//       children: [
//         Wrap(
//           spacing: 8,
//           alignment: WrapAlignment.spaceAround,
//           direction: Axis.horizontal,
//           children: List.generate(
//             controller.painLevelList.length,
//             (index) => SizedBox(
//               // width: 20,
//               child: BottomContainer(
//                 body: controller.painLevelList[index],
//                 selected: controller.painLevel == "$index",
//                 onTap: () => controller.updatePainLevel(index),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         if (controller.painLevel != "" && controller.painLevel != "0") ...[
//           const Text(
//             "متى يحصل الألم؟",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 5),
//           ContainerTextFormField(
//             controller: controller.painTimesController,
//             // maxLines: 2,
            
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildMoreDetailsSection(
//       SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "تفاصيل اضافية",
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text("هل تعاني من امراض مزمنة؟"),
//             BottomContainer(
//               body: "لا",
//               selected: controller.chronicDiseases == "لا",
//               onTap: () => controller.updateChronicDiseases("لا"),
//             ),
//             BottomContainer(
//               body: "نعم",
//               selected: controller.chronicDiseases == "نعم",
//               onTap: () => controller.updateChronicDiseases("نعم"),
//             ),
//           ],
//         ),
//         if (controller.chronicDiseases == "نعم") ...[
//           const SizedBox(height: 20),
//           const Text(
//             "اذكر المرض المزمن:",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ContainerTextFormField(
//             controller: controller.chronicDiseasesController,
//             hintText: "مثال: السكري، ارتفاع ضغط الدم، الربو...",
//             validator: (value) {
//               if (controller.chronicDiseases == "نعم" &&
//                   (value == null || value.trim().isEmpty)) {
//                 return 'الرجاء ذكر الأمراض المزمنة';
//               }
//               return null;
//             },
//           ),
//         ],
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text("هل تتناول أدوية أو مكملات؟"),
//             BottomContainer(
//               body: "لا",
//               selected: controller.medicines == "لا",
//               onTap: () => controller.updateMedicines("لا"),
//             ),
//             BottomContainer(
//               body: "نعم",
//               selected: controller.medicines == "نعم",
//               onTap: () => controller.updateMedicines("نعم"),
//             ),
//           ],
//         ),
//         if (controller.medicines == "نعم") ...[
//           const SizedBox(height: 20),
//           const Text(
//             "اذكر الأدوية أو المكملات:",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ContainerTextFormField(
//             controller: controller.medicinesController,
//             hintText: "مثال: مسكنات، فيتامينات، أدوية الضغط...",
//             validator: (value) {
//               if (controller.medicines == "نعم" &&
//                   (value == null || value.trim().isEmpty)) {
//                 return 'الرجاء ذكر الأدوية أو المكملات';
//               }
//               return null;
//             },
//           ),
//         ],
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text("      هل تمت معالجته سابقًا؟"),
//             BottomContainer(
//               body: "لا",
//               selected: controller.previousTreatment == "لا",
//               onTap: () => controller.updatePreviousTreatment("لا"),
//             ),
//             BottomContainer(
//               body: "نعم",
//               selected: controller.previousTreatment == "نعم",
//               onTap: () => controller.updatePreviousTreatment("نعم"),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildToothPositionSection(
//       SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "حدد السن المراد معالجته",
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: controller.toothPositionController,
//                   decoration: const InputDecoration(
//                     labelText: 'رقم السن',
//                     // hintText: 'أدخل رقم السن (مثال: 11 أو 46)',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: FaIcon(FontAwesomeIcons.tooth),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'الرجاء إدخال موقع السن';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 const Text(
//                   "تلميح",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 IconButton(
//                   onPressed: _showToothPositionHint,
//                   icon: const Icon(
//                     Icons.help_outline,
//                     size: 28,
//                     color: Colors.blue,
//                   ),
//                   tooltip: 'عرض خريطة الأسنان',
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "سيتم استخدام رقم السن لتحديد الموقع بدقة",
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey.shade600,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGenderSection(SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "الجنس",
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             BottomContainer(
//               body: "أنثى",
//               selected: controller.gender == "female",
//               onTap: () => controller.updateGender("female"),
//             ),
//             BottomContainer(
//               body: "ذكر",
//               selected: controller.gender == "male",
//               onTap: () => controller.updateGender("male"),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         if (controller.gender == "")
//           Text(
//             "الرجاء تحديد الجنس",
//             style: TextStyle(
//               color: Colors.orange.shade700,
//               fontSize: 12,
//             ),
//           ),
//         if (controller.gender == "female")
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("هل هي حامل"),
//               BottomContainer(
//                 body: "لا",
//                 selected: controller.regnant == false,
//                 onTap: () => controller.updateRegnant(false),
//               ),
//               BottomContainer(
//                 body: "نعم",
//                 selected: controller.regnant == true,
//                 onTap: () => controller.updateRegnant(true),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildAgeSection(SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "العمر",
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: TextFormField(
//             controller: controller.ageController,
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             decoration: const InputDecoration(
//               labelText: 'العمر',
//               border: OutlineInputBorder(),
//               filled: true,
//               fillColor: Colors.white,
//               prefixIcon: Icon(Icons.person_outline),
//               suffixText: 'سنة',
//             ),
            
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAttachmentSection(
//       SubmittingRequestPatientControllerImp controller) {
//     return BackgoundContainerDialog(
//       title: "إرفاق صورة للحالة",
//       children: [
//         Column(
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue.shade300, width: 2),
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.blue.shade50,
//               ),
//               child: IconButton(
//                 onPressed: _uploadImage,
//                 icon: const Icon(
//                   Icons.camera_alt_outlined,
//                   size: 40,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "انقر لرفع صورة السن",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "(اختياري)",
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey.shade600,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   void _showToothPositionHint() {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: () => Get.back(),
//                   icon: const Icon(Icons.close),
//                 ),
//                 const Text(
//                   "اختر رقم السن بعناية حسب المخطط التالي:",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Image.asset(
//                     "images/images_asnan/images (3).jpeg",
//                     fit: BoxFit.contain,
//                     height: 300,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "الرقم يشير إلى موقع السن في الفك",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => Get.back(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     minimumSize: const Size(150, 45),
//                   ),
//                   child: const Text(
//                     "تم الفهم",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _uploadImage() {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "اختر طريقة الرفع",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildUploadOption(
//                   icon: Icons.camera_alt,
//                   text: "الكاميرا",
//                   onTap: () async {
//                     final pickedFile = await ImagePicker()
//                         .pickImage(source: ImageSource.camera);
//                     if (pickedFile != null) {
//                       controller.image = File(pickedFile.path);
//                       Get.back();
                      
//                       // await controller.uploadRequestPicture(image);
//                     }
//                   },
//                 ),
//                 _buildUploadOption(
//                   icon: Icons.photo_library,
//                   text: "المعرض",
//                   onTap: () async {
//                     final pickedFile = await ImagePicker()
//                         .pickImage(source: ImageSource.gallery);
//                     if (pickedFile != null) {
//                       controller.image = File(pickedFile.path);
//                       Get.back();
//                       // await controller.uploadRequestPicture(image);
//                     }
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text("إلغاء"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadOption({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(50),
//           child: Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(50),
//               border: Border.all(color: Colors.blue.shade200),
//             ),
//             child: Icon(icon, size: 30, color: Colors.blue),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(text),
//       ],
//     );
//   }

// }