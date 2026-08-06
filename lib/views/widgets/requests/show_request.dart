// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
// import 'package:gr_flutter/utils/app_constants/app_constants.dart';
// import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
// import '../../../models/requests_models/treatment_request_model.dart';
// import '../row_item_request.dart';

// class ShowRequest extends StatelessWidget {
//   // final PatientRequestControllerImp controller = Get.find();
//   // final Map toothLocation;
//   final List<Widget> children;
//   final TreatmentRequestModel requestModel;

//   const ShowRequest({
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
//             image: AssetImage(AppImages.authBackground
//               ,
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
//           border: Border.all(color: AppColors.white, width: 1.5, strokeAlign: 10),
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
//                     color: AppColors.black,
//                     shadows: [Shadow(color: AppColors.white, blurRadius: 10)],
//                   ),
//                 ),
//                 Text(
//                   "",
//                   // requestModel.status!,
//                   style: TextStyle(
//                     color: AppColors.success,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     shadows: [
//                       Shadow(
//                         color: AppColors.white,
//                         blurRadius: 1,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   "",
//                   // "${requestModel.updatedAt!.day}/${requestModel.updatedAt!.month}/${requestModel.updatedAt!.year}",
//                   style: TextStyle(
//                     color: AppColors.success,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     shadows: [
//                       Shadow(
//                         color: AppColors.white,
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
//                         height: requestModel.requestion!.photo == null
//                             ? 50
//                             : Get.width * 0.7,
//                         width: requestModel.requestion!.photo == null
//                             ? 50
//                             : Get.width * 0.7,
//                         decoration: BoxDecoration(
//                           image: requestModel.requestion!.photo == null
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
//                             color: AppColors.grey,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Center(
//                           child: requestModel.requestion!.photo != null
//                               ? null
//                               : FaIcon(
//                                   FontAwesomeIcons.tooth,
//                                   color: AppColors.white,
//                                 ),
//                         )
//                         // :
//                         // Image.network("${requestModel.photo!.url}",fit: BoxFit.cover,),
//                         ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "نوع الحالة : ",
//                       valueItem: requestModel.caseType!.caseType??"",
//                       // valueItem: requestModel.caseType,
//                       isUpdate: true,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "شدة الألم: ",
//                       valueItem: "5/${requestModel.requestion!.painSeverity}",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "وقت الألم: ",
//                       valueItem: requestModel.requestion!.painTime ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "عمر المريض: ",
//                       valueItem: requestModel.requestion!.age ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: "جنس المريض: ",
//                       valueItem: requestModel.requestion!.gender ?? "غير محدد",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     RowItemRequest(
//                       keyItem: " نوع السن: ",
//                       valueItem:
//                          ToothConstants.toothLocationMap[requestModel.requestion!.toothLocation] ?? "",
//                       isUpdate: false,
//                     ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.previousTreatment != null &&
//                         requestModel.requestion!.moreDetails!.previousTreatment == true)
//                       RowItemRequest(
//                         keyItem: "معالج سابقًا: ",
//                         valueItem: "نعم السن تم معالجته سابقًا",
//                         isUpdate: false,
//                       ),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.chronicDiseases != null &&
//                         requestModel.requestion!.moreDetails!.chronicDiseases != "")
//                       RowItemRequest(
//                           keyItem: "أمراض مزمنة: ",
//                           valueItem: requestModel.requestion!.moreDetails!.chronicDiseases!,
//                           isUpdate: false),
//                     Container(
//                       color: AppColors.white,
//                       height: 1,
//                     ),
//                     if (requestModel.requestion!.moreDetails != null &&
//                         requestModel.requestion!.moreDetails!.medicines != null &&
//                         requestModel.requestion!.moreDetails!.medicines != "")
//                       RowItemRequest(
//                           keyItem: "أدوية ومكملات: ",
//                           valueItem: requestModel.requestion!.moreDetails!.medicines!,
//                           isUpdate: false),
//                     Container(
//                       color: AppColors.white,
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
//                     if (requestModel.requestion!.isPregnant != null &&
//                         requestModel.requestion!.isPregnant == true)
//                       RowItemRequest(
//                         keyItem: " ملاحظة",
//                         valueItem: "البنية حامل",
//                         isUpdate: false,
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
