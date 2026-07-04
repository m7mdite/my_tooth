
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
// import 'package:gr_flutter/controllers/conversations_controllers/conversations_controller.dart';
// import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
// import '../row_item_request.dart';
// import '../../public_views/view_other_profile.dart';

// class ShowRequestProcessing extends StatelessWidget {
//   // final PatientRequestControllerImp controller = Get.find();
//   // final Map toothLocation;
//   final ConversationsController conversationsController =
//       Get.put(ConversationsController());
//   final List<Widget> children;
//   final TreatmentRequestProcessingSModel requestModel;

//   ShowRequestProcessing({
//     super.key,
//     required this.requestModel,
//     // required this.toothLocation,
//     this.children = const <Widget>[],
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color.fromARGB(0, 0, 0, 0),
//       child: AnimatedContainer(
//         duration: Duration(seconds: 10),
//         curve: Curves.easeIn,
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.all(30),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               AppConstants.defaultBackgroundImage,
//             ),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.linearToSrgbGamma(),
//           ),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.elliptical(100, 10),
//             bottomLeft: Radius.elliptical(10, 100),
//             topRight: Radius.elliptical(10, 100),
//             bottomRight: Radius.elliptical(100, 10),
//           ),
//           border: Border.all(color: Colors.white, width: 1.5, strokeAlign: 10),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: Icon(
//                     Icons.cancel_outlined,
//                     size: 32,
//                     color: Colors.black,
//                     shadows: [Shadow(color: Colors.white, blurRadius: 10)],
//                   ),
//                 ),
//                 // Text(
//                 //   requestModel.status!,
//                 //   style: TextStyle(
//                 //     color: Colors.green,
//                 //     fontSize: 12,
//                 //     fontWeight: FontWeight.w400,
//                 //     shadows: [
//                 //       Shadow(
//                 //         color: Colors.white,
//                 //         blurRadius: 1,
//                 //         offset: Offset(1, 1),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 Text(
//                   requestModel.dateOfAccepting!.substring(0, 20),
//                   style: TextStyle(
//                     color: Colors.green,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     shadows: [
//                       Shadow(
//                         color: Colors.white,
//                         blurRadius: 1,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Form(
//                 child: ListView(
//                   children: [
//                     Container(
//                         height: requestModel.requestion!.photo == null ||
//                                 requestModel.requestion!.photo!.url == ""
//                             ? 50
//                             : Get.width * 0.7,
//                         width: requestModel.requestion!.photo == null ||
//                                 requestModel.requestion!.photo!.url == ""
//                             ? 50
//                             : Get.width * 0.7,
//                         decoration: BoxDecoration(
//                           image: requestModel.requestion!.photo == null ||
//                                   requestModel.requestion!.photo!.url == ""
//                               ? null
//                               : DecorationImage(
//                                   image: NetworkImage(
//                                       "${requestModel.requestion!.photo!.url}"),
//                                   fit: BoxFit.cover,
//                                 ),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.elliptical(100, 10),
//                             bottomLeft: Radius.elliptical(10, 100),
//                             topRight: Radius.elliptical(10, 100),
//                             bottomRight: Radius.elliptical(100, 10),
//                           ),
//                           border: Border.all(
//                             color: Colors.grey,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Center(
//                           child: requestModel.requestion!.photo == null ||
//                                   requestModel.requestion!.photo!.url == ""
//                               ? null
//                               : FaIcon(
//                                   FontAwesomeIcons.tooth,
//                                   color: Colors.white,
//                                 ),
//                         )
//                         // :
//                         // Image.network("${requestModel.photo!.url}",fit: BoxFit.cover,),
//                         ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "نوع الحالة : ",
//                       valueItem: requestModel.caseType!.caseType ?? "",
//                       // valueItem: requestModel.caseType,
//                       isUpdate: true,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "شدة الألم: ",
//                       valueItem: "5/${requestModel.requestion!.painSeverity}",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "وقت الألم: ",
//                       valueItem:
//                           requestModel.requestion!.painTime ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "عمر المريض: ",
//                       valueItem: requestModel.requestion!.age ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "جنس المريض: ",
//                       valueItem: requestModel.requestion!.gender ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: " نوع السن: ",
//                       valueItem: ToothConstants.toothLocationMap[
//                               requestModel.requestion!.toothLocation] ??
//                           "",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel
//                                 .requestion!.moreDetails!.previousTreatment !=
//                             null &&
//                         requestModel
//                                 .requestion!.moreDetails!.previousTreatment ==
//                             true)
//                       RowItemRequest(
//                         keyItem: "معالج سابقًا: ",
//                         valueItem: "نعم السن تم معالجته سابقًا",
//                         isUpdate: false,
//                       ),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.chronicDiseases !=
//                             null &&
//                         requestModel.requestion!.moreDetails!.chronicDiseases !=
//                             "")
//                       RowItemRequest(
//                           keyItem: "أمراض مزمنة: ",
//                           valueItem: requestModel
//                               .requestion!.moreDetails!.chronicDiseases!,
//                           isUpdate: false),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.medicines !=
//                             null &&
//                         requestModel.requestion!.moreDetails!.medicines != "")
//                       RowItemRequest(
//                           keyItem: "أدوية ومكملات: ",
//                           valueItem:
//                               requestModel.requestion!.moreDetails!.medicines!,
//                           isUpdate: false),
//                     Container(
//                       color: Colors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.notes != null)
//                       RowItemRequest(
//                         keyItem: "ملاحظة ",
//                         valueItem: requestModel.requestion!.moreDetails!.notes!,
//                         isUpdate: false,
//                       ),
//                     if (requestModel.courseInfo != null &&
//                         requestModel.courseInfo!.courseName != null)
//                       RowItemRequest(
//                         keyItem: "اسم المادة",
//                         valueItem: requestModel.courseInfo!.courseName ?? "",
//                         isUpdate: false,
//                       ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     if (requestModel.overseer != null &&
//                         requestModel.overseer!.firstName != null)
//                       InkWell(
//                         onTap: () async {
                         
//                           PublicController publicController = Get.find<PublicController>();
//                           await publicController
//                               .getOtherProfile(requestModel.overseer!.user!);

                          
//                           Get.dialog(
//                             Container(
//                               padding: EdgeInsets.all(6),
//                               margin: EdgeInsets.symmetric(
//                                 horizontal: Get.width * 0.1,
//                                 vertical: Get.height * 0.1,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.elliptical(1, 10),
//                                   topRight: Radius.elliptical(10, 1),
//                                   bottomLeft: Radius.elliptical(10, 1),
//                                   bottomRight: Radius.elliptical(1, 10),
//                                 ),
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   strokeAlign: 5,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: ViewOtherProfile(
//                                 profile: publicController.otherProfile,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           color: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               FaIcon(
//                                 FontAwesomeIcons.userDoctor,
//                                 size: 16,
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 "${requestModel.overseer!.firstName} ${requestModel.overseer!.fatherName}  ${requestModel.overseer!.lastName}",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     if (requestModel.patient != null &&
//                         requestModel.patient!.firstName != null)
//                       InkWell(
//                         onTap: () async {
                         
//                           PublicController publicController = Get.find<PublicController>();
//                           await publicController
//                               .getOtherProfile(requestModel.patient!.user!);

                          
//                           Get.dialog(
//                             Container(
//                               padding: EdgeInsets.all(6),
//                               margin: EdgeInsets.symmetric(
//                                 horizontal: Get.width * 0.1,
//                                 vertical: Get.height * 0.1,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.elliptical(1, 10),
//                                   topRight: Radius.elliptical(10, 1),
//                                   bottomLeft: Radius.elliptical(10, 1),
//                                   bottomRight: Radius.elliptical(1, 10),
//                                 ),
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   strokeAlign: 5,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: ViewOtherProfile(
//                                 profile: publicController.otherProfile,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           color: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               FaIcon(
//                                 FontAwesomeIcons.userNinja,
//                                 size: 16,
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 "${requestModel.patient!.firstName} ${requestModel.patient!.fatherName}  ${requestModel.patient!.lastName}",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     if (requestModel.student != null &&
//                         requestModel.student!.firstName != null)
//                       InkWell(
//                         onTap: () async {
                         
//                           PublicController publicController = Get.find<PublicController>();
//                           await publicController
//                               .getOtherProfile(requestModel.student!.user!);

                          
//                           Get.dialog(
//                             Container(
//                               padding: EdgeInsets.all(6),
//                               margin: EdgeInsets.symmetric(
//                                 horizontal: Get.width * 0.1,
//                                 vertical: Get.height * 0.1,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.elliptical(1, 10),
//                                   topRight: Radius.elliptical(10, 1),
//                                   bottomLeft: Radius.elliptical(10, 1),
//                                   bottomRight: Radius.elliptical(1, 10),
//                                 ),
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   strokeAlign: 5,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: ViewOtherProfile(
//                                 profile: publicController.otherProfile,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           color: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               FaIcon(
//                                 FontAwesomeIcons.userNinja,
//                                 size: 16,
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 "${requestModel.student!.firstName} ${requestModel.student!.fatherName}  ${requestModel.student!.lastName}",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//             ...children
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
// import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
// import '../row_item_request.dart';
// import '../../public_views/view_other_profile.dart';

// class ShowRequestProcessing extends StatefulWidget {
//   final TreatmentRequestProcessingSModel requestModel;
//   final List<Widget> children;

//   const ShowRequestProcessing({
//     super.key,
//     required this.requestModel,
//     this.children = const <Widget>[],
//   });

//   @override
//   State<ShowRequestProcessing> createState() => _ShowRequestProcessingState();
// }

// class _ShowRequestProcessingState extends State<ShowRequestProcessing>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(16),
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: SafeArea(
//             child: Container(
//               constraints: BoxConstraints(
//                 maxHeight: Get.height * 0.92,
//                 maxWidth: Get.width * 0.95,
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colors.white.withValues(alpha: 0.98),
//                     Colors.blue.shade50.withValues(alpha: 0.95),
//                   ],
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.elliptical(120, 15),
//                   bottomLeft: Radius.elliptical(15, 120),
//                   topRight: Radius.elliptical(15, 120),
//                   bottomRight: Radius.elliptical(120, 15),
//                 ),
//                 border: Border.all(
//                   color: Colors.blue.shade300,
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.shade200.withValues(alpha: 0.4),
//                     blurRadius: 30,
//                     spreadRadius: 5,
//                     offset: const Offset(0, 10),
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.elliptical(120, 15),
//                   bottomLeft: Radius.elliptical(15, 120),
//                   topRight: Radius.elliptical(15, 120),
//                   bottomRight: Radius.elliptical(120, 15),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // ===== شريط العنوان =====
//                     _buildHeader(),

//                     // ===== المحتوى الرئيسي =====
//                     Expanded(
//                       child: SingleChildScrollView(
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 8),
//                             _buildPhotoCard(),
//                             const SizedBox(height: 12),
//                             _buildInfoCards(),
//                             const SizedBox(height: 12),
//                             _buildProfileCards(),
//                             const SizedBox(height: 8),
//                             ...widget.children,
//                             const SizedBox(height: 16),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ===================== شريط العنوان =====================
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade700, Colors.blue.shade400],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.elliptical(120, 15),
//           topRight: Radius.elliptical(15, 120),
//         ),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.close_rounded, color: Colors.white),
//             onPressed: Get.back,
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.white.withValues(alpha: 0.2),
//               shape: const CircleBorder(),
//             ),
//           ),
//           const Spacer(),
//           Text(
//             'تفاصيل الطلب',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
//             ),
//           ),
//           const Spacer(),
//           if (widget.requestModel.dateOfAccepting != null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.2),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 _formatDate(widget.requestModel.dateOfAccepting!),
//                 style: const TextStyle(color: Colors.white, fontSize: 11),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // ===================== بطاقة الصورة =====================
//   Widget _buildPhotoCard() {
//     final photo = widget.requestModel.requestion?.photo;
//     final hasPhoto = photo != null && photo.url != null && photo.url!.isNotEmpty;

//     return Container(
//       height: hasPhoto ? Get.width * 0.65 : 80,
//       width: hasPhoto ? Get.width * 0.85 : double.infinity,
//       decoration: BoxDecoration(
//         image: hasPhoto
//             ? DecorationImage(
//                 image: NetworkImage("http://localhost:5000/${photo.url!}"),
//                 fit: BoxFit.cover,
//               )
//             : null,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.elliptical(80, 10),
//           bottomLeft: Radius.elliptical(10, 80),
//           topRight: Radius.elliptical(10, 80),
//           bottomRight: Radius.elliptical(80, 10),
//         ),
//         border: Border.all(color: Colors.blue.shade200, width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: hasPhoto
//           ? null
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.image_outlined,
//                     size: 40,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'لا توجد صورة',
//                     style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // ===================== بطاقات المعلومات =====================
//   Widget _buildInfoCards() {
//     final req = widget.requestModel.requestion;
//     final more = req?.moreDetails;

//     final List<Map<String, dynamic>> infoList = [
//       {'icon': Icons.medical_services, 'label': 'نوع الحالة', 'value': widget.requestModel.caseType?.caseType ?? ''},
//       {'icon': Icons.speed, 'label': 'شدة الألم', 'value': '${req?.painSeverity ?? 0} / 5'},
//       {'icon': Icons.access_time, 'label': 'وقت الألم', 'value': req?.painTime ?? 'غير محدد'},
//       {'icon': Icons.cake, 'label': 'عمر المريض', 'value': req?.age ?? 'غير محدد'},
//       {'icon': Icons.person, 'label': 'جنس المريض', 'value': req?.gender ?? 'غير محدد'},
//       {'icon': Icons.medical_information, 'label': 'نوع السن', 'value': ToothConstants.toothLocationMap[req?.toothLocation] ?? ''},
//       if (more?.previousTreatment == true) {'icon': Icons.history, 'label': 'معالج سابقًا', 'value': 'نعم'},
//       if (more?.chronicDiseases != null && more!.chronicDiseases!.isNotEmpty) {'icon': Icons.health_and_safety, 'label': 'أمراض مزمنة', 'value': more.chronicDiseases!},
//       if (more?.medicines != null && more!.medicines!.isNotEmpty) {'icon': Icons.medication, 'label': 'أدوية ومكملات', 'value': more.medicines!},
//       if (more?.notes != null && more!.notes!.isNotEmpty) {'icon': Icons.note, 'label': 'ملاحظة', 'value': more.notes!},
//       if (widget.requestModel.courseInfo?.courseName != null) {'icon': Icons.book, 'label': 'المادة', 'value': widget.requestModel.courseInfo!.courseName!},
//     ];

//     return Column(
//       children: infoList.map((item) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 6),
//           child: _buildInfoCard(item['icon'], item['label'], item['value']),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildInfoCard(IconData icon, String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.85),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.elliptical(40, 6),
//           bottomLeft: Radius.elliptical(6, 40),
//           topRight: Radius.elliptical(6, 40),
//           bottomRight: Radius.elliptical(40, 6),
//         ),
//         border: Border.all(color: Colors.blue.shade100, width: 0.8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.03),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 18, color: Colors.blue.shade700),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
//           ),
//           const Spacer(),
//           Flexible(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.end,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ===================== بطاقات الملفات الشخصية =====================
//   Widget _buildProfileCards() {
//     final users = <Map<String, dynamic>>[];

//     if (widget.requestModel.overseer != null) {
//       users.add({
//         'id': widget.requestModel.overseer!.user,
//         'firstName': widget.requestModel.overseer!.firstName,
//         'fatherName': widget.requestModel.overseer!.fatherName,
//         'lastName': widget.requestModel.overseer!.lastName,
//         'icon': FontAwesomeIcons.userDoctor,
//         'label': 'المشرف',
//         'color': Colors.green.shade700,
//       });
//     }

//     if (widget.requestModel.patient != null) {
//       users.add({
//         'id': widget.requestModel.patient!.user,
//         'firstName': widget.requestModel.patient!.firstName,
//         'fatherName': widget.requestModel.patient!.fatherName,
//         'lastName': widget.requestModel.patient!.lastName,
//         'icon': FontAwesomeIcons.user,
//         'label': 'المريض',
//         'color': Colors.blue.shade700,
//       });
//     }

//     if (widget.requestModel.student != null) {
//       users.add({
//         'id': widget.requestModel.student!.user,
//         'firstName': widget.requestModel.student!.firstName,
//         'fatherName': widget.requestModel.student!.fatherName,
//         'lastName': widget.requestModel.student!.lastName,
//         'icon': FontAwesomeIcons.userGraduate,
//         'label': 'الطالب',
//         'color': Colors.purple.shade700,
//       });
//     }

//     if (users.isEmpty) return const SizedBox.shrink();

//     return Column(
//       children: users.map((user) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 6),
//           child: _buildProfileCard(user),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildProfileCard(Map<String, dynamic> user) {
//     return InkWell(
//       onTap: () async {
//         final controller = Get.find<PublicController>();
//         await controller.getOtherProfile(user['id']);
//         Get.dialog(
//           Container(
//             padding: const EdgeInsets.all(6),
//             margin: EdgeInsets.symmetric(
//               horizontal: Get.width * 0.1,
//               vertical: Get.height * 0.1,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.elliptical(1, 10),
//                 topRight: Radius.elliptical(10, 1),
//                 bottomLeft: Radius.elliptical(10, 1),
//                 bottomRight: Radius.elliptical(1, 10),
//               ),
//               border: Border.all(color: Colors.white, width: 1.5),
//             ),
//             child: ViewOtherProfile(profile: controller.otherProfile),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.85),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.elliptical(40, 6),
//             bottomLeft: Radius.elliptical(6, 40),
//             topRight: Radius.elliptical(6, 40),
//             bottomRight: Radius.elliptical(40, 6),
//           ),
//           border: Border.all(color: Colors.blue.shade100, width: 0.8),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 16,
//               backgroundColor: (user['color'] as Color).withValues(alpha: 0.15),
//               child: FaIcon(
//                 user['icon'],
//                 size: 18,
//                 color: user['color'],
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               user['label'],
//               style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
//             ),
//             const Spacer(),
//             Flexible(
//               child: Text(
//                 '${user['firstName']} ${user['fatherName'] ?? ''} ${user['lastName'] ?? ''}',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ===================== دوال مساعدة =====================
//   String _formatDate(String dateTimeStr) {
//     try {
//       final date = DateTime.parse(dateTimeStr);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (_) {
//       return dateTimeStr.substring(0, 10);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
import '../row_item_request.dart';
import '../../public_views/view_other_profile.dart';

class ShowRequestProcessing extends StatefulWidget {
  final TreatmentRequestProcessingSModel requestModel;
  final List<Widget> children;

  const ShowRequestProcessing({
    super.key,
    required this.requestModel,
    this.children = const <Widget>[],
  });

  @override
  State<ShowRequestProcessing> createState() => _ShowRequestProcessingState();
}

class _ShowRequestProcessingState extends State<ShowRequestProcessing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.92,
              maxWidth: Get.width * 0.95,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.defaultBackgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(120, 15),
                bottomLeft: Radius.elliptical(15, 120),
                topRight: Radius.elliptical(15, 120),
                bottomRight: Radius.elliptical(120, 15),
              ),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(120, 15),
                bottomLeft: Radius.elliptical(15, 120),
                topRight: Radius.elliptical(15, 120),
                bottomRight: Radius.elliptical(120, 15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // شريط العنوان
                  _buildHeader(),
                  // المحتوى القابل للتمرير
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildPhotoCard(),
                          const SizedBox(height: 12),
                          _buildInfoCards(),
                          const SizedBox(height: 12),
                          _buildProfileCards(),
                          const SizedBox(height: 8),
                          ...widget.children,
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== شريط العنوان =====================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(120, 15),
          topRight: Radius.elliptical(15, 120),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: Get.back,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              shape: const CircleBorder(),
            ),
          ),
          const Spacer(),
          Text(
            'تفاصيل الطلب',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
          const Spacer(),
          if (widget.requestModel.dateOfAccepting != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDate(widget.requestModel.dateOfAccepting!),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== بطاقة الصورة =====================
  Widget _buildPhotoCard() {
    final photo = widget.requestModel.requestion?.photo;
    final hasPhoto = photo != null && photo.url != null && photo.url!.isNotEmpty;

    return Container(
      height: hasPhoto ? Get.width * 0.6 : 80,
      width: hasPhoto ? Get.width * 0.85 : double.infinity,
      decoration: BoxDecoration(
        image: hasPhoto
            ? DecorationImage(
                image: NetworkImage("http://localhost:5000/${photo!.url!}"),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(80, 10),
          bottomLeft: Radius.elliptical(10, 80),
          topRight: Radius.elliptical(10, 80),
          bottomRight: Radius.elliptical(80, 10),
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: hasPhoto
          ? null
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'لا توجد صورة',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  // ===================== بطاقات المعلومات =====================
  Widget _buildInfoCards() {
    final req = widget.requestModel.requestion;
    final more = req?.moreDetails;

    final List<Map<String, dynamic>> infoList = [
      {'icon': Icons.medical_services, 'label': 'نوع الحالة', 'value': widget.requestModel.caseType?.caseType ?? ''},
      {'icon': Icons.speed, 'label': 'شدة الألم', 'value': '${req?.painSeverity ?? 0} / 5'},
      {'icon': Icons.access_time, 'label': 'وقت الألم', 'value': req?.painTime ?? 'غير محدد'},
      {'icon': Icons.cake, 'label': 'عمر المريض', 'value': req?.age ?? 'غير محدد'},
      {'icon': Icons.person, 'label': 'جنس المريض', 'value': req?.gender ?? 'غير محدد'},
      {'icon': Icons.medical_information, 'label': 'نوع السن', 'value': ToothConstants.toothLocationMap[req?.toothLocation] ?? ''},
      if (more?.previousTreatment == true) {'icon': Icons.history, 'label': 'معالج سابقًا', 'value': 'نعم'},
      if (more?.chronicDiseases != null && more!.chronicDiseases!.isNotEmpty) {'icon': Icons.health_and_safety, 'label': 'أمراض مزمنة', 'value': more.chronicDiseases!},
      if (more?.medicines != null && more!.medicines!.isNotEmpty) {'icon': Icons.medication, 'label': 'أدوية ومكملات', 'value': more.medicines!},
      if (more?.notes != null && more!.notes!.isNotEmpty) {'icon': Icons.note, 'label': 'ملاحظة', 'value': more.notes!},
      if (widget.requestModel.courseInfo?.courseName != null) {'icon': Icons.book, 'label': 'المادة', 'value': widget.requestModel.courseInfo!.courseName!},
    ];

    return Column(
      children: infoList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildInfoCard(item['icon'], item['label'], item['value']),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        border: Border.all(color: Colors.blueAccent.withAlpha(100), width: 1.5,strokeAlign: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== بطاقات الملفات الشخصية =====================
  Widget _buildProfileCards() {
    final users = <Map<String, dynamic>>[];

    if (widget.requestModel.overseer != null) {
      users.add({
        'id': widget.requestModel.overseer!.user,
        'firstName': widget.requestModel.overseer!.firstName,
        'fatherName': widget.requestModel.overseer!.fatherName,
        'lastName': widget.requestModel.overseer!.lastName,
        'icon': FontAwesomeIcons.userDoctor,
        'label': 'المشرف',
        'color': Colors.green.shade700,
      });
    }

    if (widget.requestModel.patient != null) {
      users.add({
        'id': widget.requestModel.patient!.user,
        'firstName': widget.requestModel.patient!.firstName,
        'fatherName': widget.requestModel.patient!.fatherName,
        'lastName': widget.requestModel.patient!.lastName,
        'icon': FontAwesomeIcons.user,
        'label': 'المريض',
        'color': Colors.blue.shade700,
      });
    }

    if (widget.requestModel.student != null) {
      users.add({
        'id': widget.requestModel.student!.user,
        'firstName': widget.requestModel.student!.firstName,
        'fatherName': widget.requestModel.student!.fatherName,
        'lastName': widget.requestModel.student!.lastName,
        'icon': FontAwesomeIcons.userGraduate,
        'label': 'الطالب',
        'color': Colors.purple.shade700,
      });
    }

    if (users.isEmpty) return const SizedBox.shrink();

    return Column(
      children: users.map((user) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildProfileCard(user),
        );
      }).toList(),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> user) {
    return InkWell(
      onTap: () async {
        final controller = Get.find<PublicController>();
        await controller.getOtherProfile(user['id']);
        Get.dialog(
          Container(
            padding: const EdgeInsets.all(6),
            margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.1,
              vertical: Get.height * 0.1,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(1, 10),
                topRight: Radius.elliptical(10, 1),
                bottomLeft: Radius.elliptical(10, 1),
                bottomRight: Radius.elliptical(1, 10),
              ),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ViewOtherProfile(profile: controller.otherProfile),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(40, 6),
            bottomLeft: Radius.elliptical(6, 40),
            topRight: Radius.elliptical(6, 40),
            bottomRight: Radius.elliptical(40, 6),
          ),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: (user['color'] as Color).withValues(alpha: 0.15),
              child: FaIcon(
                user['icon'],
                size: 18,
                color: user['color'],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              user['label'],
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                '${user['firstName']} ${user['fatherName'] ?? ''} ${user['lastName'] ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== دوال مساعدة =====================
  String _formatDate(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateTimeStr.substring(0, 10);
    }
  }
}