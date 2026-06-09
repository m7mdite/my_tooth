
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/controllers/conversations_controllers/conversations_controller.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
import '../row_item_request.dart';
import '../../public_views/view_other_profile.dart';

class ShowRequestProcessing extends StatelessWidget {
  // final PatientRequestControllerImp controller = Get.find();
  // final Map toothLocation;
  final ConversationsController conversationsController =
      Get.put(ConversationsController());
  final List<Widget> children;
  final TreatmentRequestProcessingSModel requestModel;

  ShowRequestProcessing({
    super.key,
    required this.requestModel,
    // required this.toothLocation,
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(0, 0, 0, 0),
      child: AnimatedContainer(
        duration: Duration(seconds: 10),
        curve: Curves.easeIn,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppConstants.defaultBackgroundImage,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          border: Border.all(color: Colors.white, width: 1.5, strokeAlign: 10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 32,
                    color: Colors.black,
                    shadows: [Shadow(color: Colors.white, blurRadius: 10)],
                  ),
                ),
                // Text(
                //   requestModel.status!,
                //   style: TextStyle(
                //     color: Colors.green,
                //     fontSize: 12,
                //     fontWeight: FontWeight.w400,
                //     shadows: [
                //       Shadow(
                //         color: Colors.white,
                //         blurRadius: 1,
                //         offset: Offset(1, 1),
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  requestModel.dateOfAccepting!.substring(0, 20),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Form(
                child: ListView(
                  children: [
                    Container(
                        height: requestModel.requestion!.photo == null ||
                                requestModel.requestion!.photo!.url == ""
                            ? 50
                            : Get.width * 0.7,
                        width: requestModel.requestion!.photo == null ||
                                requestModel.requestion!.photo!.url == ""
                            ? 50
                            : Get.width * 0.7,
                        decoration: BoxDecoration(
                          image: requestModel.requestion!.photo == null ||
                                  requestModel.requestion!.photo!.url == ""
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(
                                      "http://localhost:5000/${requestModel.requestion!.photo!.url}"),
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(100, 10),
                            bottomLeft: Radius.elliptical(10, 100),
                            topRight: Radius.elliptical(10, 100),
                            bottomRight: Radius.elliptical(100, 10),
                          ),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: requestModel.requestion!.photo == null ||
                                  requestModel.requestion!.photo!.url == ""
                              ? null
                              : FaIcon(
                                  FontAwesomeIcons.tooth,
                                  color: Colors.white,
                                ),
                        )
                        // :
                        // Image.network("http://localhost:5000/${requestModel.photo!.url}",fit: BoxFit.cover,),
                        ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "نوع الحالة : ",
                      valueItem: requestModel.caseType!.caseType ?? "",
                      // valueItem: requestModel.caseType,
                      isUpdate: true,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "شدة الألم: ",
                      valueItem: "5/${requestModel.requestion!.painSeverity}",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "وقت الألم: ",
                      valueItem:
                          requestModel.requestion!.painTime ?? "غير محدد",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "عمر المريض: ",
                      valueItem: requestModel.requestion!.age ?? "غير محدد",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "جنس المريض: ",
                      valueItem: requestModel.requestion!.gender ?? "غير محدد",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: " نوع السن: ",
                      valueItem: ToothConstants.toothLocationMap[
                              requestModel.requestion!.toothLocation] ??
                          "",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.requestion!.moreDetails != null &&
                        requestModel
                                .requestion!.moreDetails!.previousTreatment !=
                            null &&
                        requestModel
                                .requestion!.moreDetails!.previousTreatment ==
                            true)
                      RowItemRequest(
                        keyItem: "معالج سابقًا: ",
                        valueItem: "نعم السن تم معالجته سابقًا",
                        isUpdate: false,
                      ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.requestion!.moreDetails != null &&
                        requestModel.requestion!.moreDetails!.chronicDiseases !=
                            null &&
                        requestModel.requestion!.moreDetails!.chronicDiseases !=
                            "")
                      RowItemRequest(
                          keyItem: "أمراض مزمنة: ",
                          valueItem: requestModel
                              .requestion!.moreDetails!.chronicDiseases!,
                          isUpdate: false),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.requestion!.moreDetails != null &&
                        requestModel.requestion!.moreDetails!.medicines !=
                            null &&
                        requestModel.requestion!.moreDetails!.medicines != "")
                      RowItemRequest(
                          keyItem: "أدوية ومكملات: ",
                          valueItem:
                              requestModel.requestion!.moreDetails!.medicines!,
                          isUpdate: false),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.requestion!.moreDetails != null &&
                        requestModel.requestion!.moreDetails!.notes != null)
                      RowItemRequest(
                        keyItem: "ملاحظة ",
                        valueItem: requestModel.requestion!.moreDetails!.notes!,
                        isUpdate: false,
                      ),
                    if (requestModel.courseInfo != null &&
                        requestModel.courseInfo!.courseName != null)
                      RowItemRequest(
                        keyItem: "اسم المادة",
                        valueItem: requestModel.courseInfo!.courseName ?? "",
                        isUpdate: false,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (requestModel.overseer != null &&
                        requestModel.overseer!.firstName != null)
                      InkWell(
                        onTap: () async {
                         
                          PublicController publicController = Get.find<PublicController>();
                          await publicController
                              .getOtherProfile(requestModel.overseer!.user!);

                          
                          Get.dialog(
                            Container(
                              padding: EdgeInsets.all(6),
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.1,
                                vertical: Get.height * 0.1,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(1, 10),
                                  topRight: Radius.elliptical(10, 1),
                                  bottomLeft: Radius.elliptical(10, 1),
                                  bottomRight: Radius.elliptical(1, 10),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  strokeAlign: 5,
                                  width: 1.5,
                                ),
                              ),
                              child: ViewOtherProfile(
                                profile: publicController.otherProfile,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userDoctor,
                                size: 16,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${requestModel.overseer!.firstName} ${requestModel.overseer!.fatherName}  ${requestModel.overseer!.lastName}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (requestModel.patient != null &&
                        requestModel.patient!.firstName != null)
                      InkWell(
                        onTap: () async {
                         
                          PublicController publicController = Get.find<PublicController>();
                          await publicController
                              .getOtherProfile(requestModel.patient!.user!);

                          
                          Get.dialog(
                            Container(
                              padding: EdgeInsets.all(6),
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.1,
                                vertical: Get.height * 0.1,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(1, 10),
                                  topRight: Radius.elliptical(10, 1),
                                  bottomLeft: Radius.elliptical(10, 1),
                                  bottomRight: Radius.elliptical(1, 10),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  strokeAlign: 5,
                                  width: 1.5,
                                ),
                              ),
                              child: ViewOtherProfile(
                                profile: publicController.otherProfile,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userNinja,
                                size: 16,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${requestModel.patient!.firstName} ${requestModel.patient!.fatherName}  ${requestModel.patient!.lastName}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (requestModel.student != null &&
                        requestModel.student!.firstName != null)
                      InkWell(
                        onTap: () async {
                         
                          PublicController publicController = Get.find<PublicController>();
                          await publicController
                              .getOtherProfile(requestModel.student!.user!);

                          
                          Get.dialog(
                            Container(
                              padding: EdgeInsets.all(6),
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.1,
                                vertical: Get.height * 0.1,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(1, 10),
                                  topRight: Radius.elliptical(10, 1),
                                  bottomLeft: Radius.elliptical(10, 1),
                                  bottomRight: Radius.elliptical(1, 10),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  strokeAlign: 5,
                                  width: 1.5,
                                ),
                              ),
                              child: ViewOtherProfile(
                                profile: publicController.otherProfile,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userNinja,
                                size: 16,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${requestModel.student!.firstName} ${requestModel.student!.fatherName}  ${requestModel.student!.lastName}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ...children
          ],
        ),
      ),
    );
  }
}
