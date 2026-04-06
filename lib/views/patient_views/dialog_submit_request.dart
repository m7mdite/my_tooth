// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../controllers/patient_controller/submitting_request_patient_controller.dart';
// import '../../utils/app_constants/tooth_constants.dart';
// import '../widgets/backgound_container_dialog.dart';
// import '../widgets/bottom_controller.dart';
// import '../widgets/container_text_form_field.dart';

// class DialogSubmitRequest extends StatelessWidget {
//   final SubmittingRequestPatientControllerImp controller =
//       Get.put(SubmittingRequestPatientControllerImp());
//   final void Function()? onTapSubmit;
//   final String titleSubmit;
//   final String titleCancel;
//   final void Function()? onTapCancel;
//   DialogSubmitRequest(
//       {super.key,
//       this.onTapSubmit,
//       this.onTapCancel,
//       this.titleSubmit = "إرسال",
//       this.titleCancel = "إلغاء"});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         bottomNavigationBar: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           decoration: BoxDecoration(
//             // color: Colors.black.withOpacity(0.7),
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               BottomContainer(
//                 body: titleSubmit,
//                 onTap: onTapSubmit ?? controller.submitRequest,
//               ),
//               BottomContainer(
//                   body: titleCancel,
//                   onTap: onTapCancel ?? controller.cancelRequest),
//             ],
//           ),
//         ),
//         body: GetBuilder<SubmittingRequestPatientControllerImp>(
//           builder: (controller) {
//             return Form(
//               key: controller.formState,
//               child: ListView(
//                 padding: EdgeInsets.all(5),
//                 children: [
//                   BackgoundContainerDialog(
//                     title: "نوع المعالجة",
//                     children: [
//                       const SizedBox(height: 0),
//                       DropdownButtonFormField<String>(
//                         value: controller.caseType,
//                         items: ToothConstants.caseTypeAr
//                             .map(
//                               (String value) => DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(
//                                   value,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: controller.updateCaseType,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'اختر نوع المعالجة',
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                         ),
//                         icon: const Icon(Icons.arrow_drop_down),
//                         style: const TextStyle(color: Colors.black87),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'الرجاء اختيار نوع المعالجة';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "حدد شدة الألم من 5 ",
//                     children: [
//                       Wrap(
//                         spacing: 8,
//                         alignment: WrapAlignment.spaceAround,
//                         direction: Axis.horizontal,
//                         children: List.generate(
//                           controller.painLevelList.length,
//                           (index) => SizedBox(
//                             // width: 20,
//                             child: BottomContainer(
//                               body: controller.painLevelList[index],
//                               selected: controller.painLevel == "$index",
//                               onTap: () => controller.updatePainLevel(index),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       if (controller.painLevel != "" &&
//                           controller.painLevel != "0") ...[
//                         const Text(
//                           "متى يحصل الألم؟",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         ContainerTextFormField(
//                           controller: controller.painTimesController,
//                           // maxLines: 2,
//                         ),
//                       ],
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "الجنس",
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           BottomContainer(
//                             body: "أنثى",
//                             selected: controller.gender == "female",
//                             onTap: () => controller.updateGender("female"),
//                           ),
//                           BottomContainer(
//                             body: "ذكر",
//                             selected: controller.gender == "male",
//                             onTap: () => controller.updateGender("male"),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       if (controller.gender == "")
//                         Text(
//                           "الرجاء تحديد الجنس",
//                           style: TextStyle(
//                             color: Colors.orange.shade700,
//                             fontSize: 12,
//                           ),
//                         ),
//                       if (controller.gender == "female")
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Text("هل هي حامل"),
//                             BottomContainer(
//                               body: "لا",
//                               selected: controller.regnant == false,
//                               onTap: () => controller.updateRegnant(false),
//                             ),
//                             BottomContainer(
//                               body: "نعم",
//                               selected: controller.regnant == true,
//                               onTap: () => controller.updateRegnant(true),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "العمر",
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40),
//                         child: TextFormField(
//                           controller: controller.ageController,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           decoration: const InputDecoration(
//                             labelText: 'العمر',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                             fillColor: Colors.white,
//                             prefixIcon: Icon(Icons.person_outline),
//                             suffixText: 'سنة',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "حدد السن المراد معالجته",
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextFormField(
//                                 controller: controller.toothPositionController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'رقم السن',
//                                   // hintText: 'أدخل رقم السن (مثال: 11 أو 46)',
//                                   border: OutlineInputBorder(),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   prefixIcon: FaIcon(FontAwesomeIcons.tooth),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 validator: (value) {
//                                   if (value == null || value.trim().isEmpty) {
//                                     return 'الرجاء إدخال موقع السن';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               const Text(
//                                 "تلميح",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               IconButton(
//                                 onPressed: () {
//                                   Get.dialog(
//                                       Dialog(
//                                         child: Container(
//                                           // height: Get.height * 0.8,
//                                           // width: Get.width * 0.9,
//                                           padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: Colors.black,
//                                                 width: 2,
//                                                 strokeAlign: 7),
//                                             borderRadius: BorderRadius.only(
//                                               topLeft:
//                                                   Radius.elliptical(100, 10),
//                                               bottomLeft:
//                                                   Radius.elliptical(10, 100),
//                                               topRight:
//                                                   Radius.elliptical(10, 100),
//                                               bottomRight:
//                                                   Radius.elliptical(100, 10),
//                                             ),
//                                           ),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             mainAxisSize: MainAxisSize.min,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                   "اكتب رقم السن بناءً على المخطط التالي"),
//                                               Image.asset(
//                                                 "images/images_asnan/tooth_number.png",
//                                                 fit: BoxFit.contain,
//                                                 // height: 300,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       barrierColor: Colors.transparent);
//                                 },
//                                 icon: const Icon(
//                                   Icons.help_outline,
//                                   size: 28,
//                                   color: Colors.blue,
//                                 ),
//                                 tooltip: 'عرض خريطة الأسنان',
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "سيتم استخدام رقم السن لتحديد الموقع بدقة",
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey.shade600,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "إرفاق صورة للحالة",
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: Colors.blue.shade300, width: 2),
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.blue.shade50,
//                             ),
//                             child: IconButton(
//                               onPressed: () {
//                                 Get.bottomSheet(
//                                   Container(
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.all(20),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const Text(
//                                           "اختر طريقة الرفع",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 20),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 InkWell(
//                                                   onTap: () async {
//                                                     final pickedFile =
//                                                         await ImagePicker()
//                                                             .pickImage(
//                                                                 source:
//                                                                     ImageSource
//                                                                         .camera);
//                                                     if (pickedFile != null) {
//                                                       controller.image =
//                                                           File(pickedFile.path);
//                                                       Get.back();

//                                                       // await controller.uploadRequestPicture(image);
//                                                     }
//                                                   },
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   child: Container(
//                                                     width: 70,
//                                                     height: 70,
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           Colors.blue.shade50,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       border: Border.all(
//                                                           color: Colors
//                                                               .blue.shade200),
//                                                     ),
//                                                     child: Icon(
//                                                         Icons.camera_alt,
//                                                         size: 30,
//                                                         color: Colors.blue),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 8),
//                                                 Text(
//                                                   "الكاميرا",
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 InkWell(
//                                                   onTap: () async {
//                                                     final pickedFile =
//                                                         await ImagePicker()
//                                                             .pickImage(
//                                                                 source:
//                                                                     ImageSource
//                                                                         .gallery);
//                                                     if (pickedFile != null) {
//                                                       controller.image =
//                                                           File(pickedFile.path);
//                                                       Get.back();
//                                                       // await controller.uploadRequestPicture(image);
//                                                     }
//                                                   },
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   child: Container(
//                                                     width: 70,
//                                                     height: 70,
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           Colors.blue.shade50,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       border: Border.all(
//                                                           color: Colors
//                                                               .blue.shade200),
//                                                     ),
//                                                     child: Icon(
//                                                         Icons.photo_library,
//                                                         size: 30,
//                                                         color: Colors.blue),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 8),
//                                                 Text(
//                                                   "المعرض",
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 20),
//                                         TextButton(
//                                           onPressed: () => Get.back(),
//                                           child: const Text("إلغاء"),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(
//                                 Icons.camera_alt_outlined,
//                                 size: 40,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           const Text(
//                             "انقر لرفع صورة السن",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "(اختياري)",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey.shade600,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   BackgoundContainerDialog(
//                     title: "تفاصيل اضافية",
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text("هل تعاني من امراض مزمنة؟"),
//                           BottomContainer(
//                             body: "لا",
//                             selected: controller.chronicDiseases == "لا",
//                             onTap: () => controller.updateChronicDiseases("لا"),
//                           ),
//                           BottomContainer(
//                             body: "نعم",
//                             selected: controller.chronicDiseases == "نعم",
//                             onTap: () =>
//                                 controller.updateChronicDiseases("نعم"),
//                           ),
//                         ],
//                       ),
//                       if (controller.chronicDiseases == "نعم") ...[
//                         const SizedBox(height: 20),
//                         const Text(
//                           "اذكر المرض المزمن:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ContainerTextFormField(
//                           controller: controller.chronicDiseasesController,
//                           hintText: "مثال: السكري، ارتفاع ضغط الدم، الربو...",
//                           validator: (value) {
//                             if (controller.chronicDiseases == "نعم" &&
//                                 (value == null || value.trim().isEmpty)) {
//                               return 'الرجاء ذكر الأمراض المزمنة';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text("هل تتناول أدوية أو مكملات؟"),
//                           BottomContainer(
//                             body: "لا",
//                             selected: controller.medicines == "لا",
//                             onTap: () => controller.updateMedicines("لا"),
//                           ),
//                           BottomContainer(
//                             body: "نعم",
//                             selected: controller.medicines == "نعم",
//                             onTap: () => controller.updateMedicines("نعم"),
//                           ),
//                         ],
//                       ),
//                       if (controller.medicines == "نعم") ...[
//                         const SizedBox(height: 20),
//                         const Text(
//                           "اذكر الأدوية أو المكملات:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ContainerTextFormField(
//                           controller: controller.medicinesController,
//                           hintText: "مثال: مسكنات، فيتامينات، أدوية الضغط...",
//                           validator: (value) {
//                             if (controller.medicines == "نعم" &&
//                                 (value == null || value.trim().isEmpty)) {
//                               return 'الرجاء ذكر الأدوية أو المكملات';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text("      هل تمت معالجته سابقًا؟"),
//                           BottomContainer(
//                             body: "لا",
//                             selected: controller.previousTreatment == "لا",
//                             onTap: () =>
//                                 controller.updatePreviousTreatment("لا"),
//                           ),
//                           BottomContainer(
//                             body: "نعم",
//                             selected: controller.previousTreatment == "نعم",
//                             onTap: () =>
//                                 controller.updatePreviousTreatment("نعم"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
