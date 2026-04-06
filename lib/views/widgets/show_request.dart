import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import '../../controllers/patient_controller/patient_request_controller.dart';
import '../../models/request_model.dart';
import 'row_item_request.dart';

class ShowRequest extends StatelessWidget {
  // final PatientRequestControllerImp controller = Get.find();
  final Map toothLocation;
  final List<Widget> children;
  final RequestReceiveModel requestModel;

  const ShowRequest(
      {super.key,
      required this.requestModel,
      required this.toothLocation,
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
          border:
              Border.all(color: Colors.white, width: 1.5, strokeAlign: 10),
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
                Text(
                  requestModel.status!,
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
                Text(
                  "${requestModel.updatedAt.day}/${requestModel.updatedAt.month}/${requestModel.updatedAt.year}",
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
                        height: requestModel.photo!.url == ""
                            ? 50
                            : Get.width * 0.7,
                        width: requestModel.photo!.url == ""
                            ? 50
                            : Get.width * 0.7,
                        decoration: BoxDecoration(
                          image: requestModel.photo!.url == ""
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(
                                      "http://localhost:5000/${requestModel.photo!.url}"),
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
                          child: requestModel.photo!.url != ""
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
                      valueItem: requestModel.caseType,
                      isUpdate: true,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "شدة الألم: ",
                      valueItem: "5/${requestModel.painSeverity}",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "وقت الألم: ",
                      valueItem: requestModel.painTime,
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "عمر المريض: ",
                      valueItem: requestModel.age,
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: "جنس المريض: ",
                      valueItem: requestModel.gender,
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    RowItemRequest(
                      keyItem: " نوع السن: ",
                      valueItem:
                          toothLocation[requestModel.toothLocation] ?? "",
                      isUpdate: false,
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.moreDetails != null &&
                        requestModel.moreDetails!.previousTreatment != null &&
                        requestModel.moreDetails!.previousTreatment == true)
                      RowItemRequest(
                        keyItem: "معالج سابقًا: ",
                        valueItem: "نعم السن تم معالجته سابقًا",
                        isUpdate: false,
                      ),
                      Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.moreDetails != null &&
                        requestModel.moreDetails!.chronicDiseases != null &&
                        requestModel.moreDetails!.chronicDiseases != "" )
                      RowItemRequest(
                          keyItem: "أمراض مزمنة: ",
                          valueItem:
                              requestModel.moreDetails!.chronicDiseases!,
                          isUpdate: false),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.moreDetails != null &&
                        requestModel.moreDetails!.medicines != null &&
                        requestModel.moreDetails!.medicines != "" )
                      RowItemRequest(
                          keyItem: "أدوية ومكملات: ",
                          valueItem: requestModel.moreDetails!.medicines!,
                          
                          isUpdate: false),
                    Container(
                      color: Colors.white,
                      height: 1,
                    ),
                    if (requestModel.moreDetails != null &&
                        requestModel.moreDetails!.notes != null)
                      RowItemRequest(
                        keyItem: "ملاحظة ",
                        valueItem: requestModel.moreDetails!.notes!,
                        isUpdate: false,
                      ),
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
