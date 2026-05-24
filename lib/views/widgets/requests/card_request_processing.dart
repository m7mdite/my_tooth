import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';
import '../../../utils/app_constants/tooth_constants.dart';

class CardRequestProcessing extends StatelessWidget {
  final TreatmentRequestProcessingSModel requestModel;
  final Map? toothLocation = ToothConstants.toothLocationMap;
  final void Function()? onTap;
  const CardRequestProcessing({
    super.key,
    required this.requestModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap!();
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppConstants.defaultBackgroundImage,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          boxShadow: [
            BoxShadow(
              color: requestModel.requestion!.gender == 'male'
                  ? Colors.blue
                  : requestModel.requestion!.gender == 'female'
                      ? Colors.pink
                      : Colors.white,
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            strokeAlign: 10,
            color: requestModel.requestion!.gender == 'male'
                ? Colors.blue
                : requestModel.requestion!.gender == 'female'
                    ? Colors.pink
                    : Colors.white,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  toothLocation?[requestModel.requestion!.toothLocation] ??
                      "غير محدد",
                  style: TextStyle(
                    color: Colors.black,
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
                SizedBox(
                  width: 5,
                ),
                FaIcon(
                  FontAwesomeIcons.tooth,
                  color: Colors.white,
                ),
              ],
            ),
              Container(
              color: Colors.white,
              height: 1,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(requestModel.courseInfo != null)...[
                Text(
                  "المادة",
                  style: TextStyle(fontSize: 12),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(1, 1)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Text(requestModel.courseInfo!.courseName ?? ""
                        // requestModel.caseType,
                        ),
                  ),
                ),],
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  // child: Column(mainAxisSize: MainAxisSize.max,),
                ),
                Text(
                  "الحالة",
                  style: TextStyle(fontSize: 12),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(1, 1)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Text(requestModel.caseType!.caseType ?? ""
                        // requestModel.caseType,
                        ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "شدة الألم: ",
                  style: TextStyle(fontSize: 12),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(1, 1)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: requestModel.requestion!.painSeverity! >= 1
                                  ? Colors.redAccent
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: requestModel.requestion!.painSeverity! >= 2
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: requestModel.requestion!.painSeverity! >= 3
                                  ? Colors.redAccent
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: requestModel.requestion!.painSeverity! >= 4
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: requestModel.requestion!.painSeverity! >= 5
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "وقت الألم: ",
                  style: TextStyle(fontSize: 12),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Text(
                      requestModel.requestion!.painTime ?? "غير محدد",
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   requestModel.requestion!.,
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
                Text('',
                  // requestModel.dateOfAccepting!.substring(0, 20),
                  style: TextStyle(
                    color: Colors.green,
                    overflow: TextOverflow.clip,
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
            if (requestModel.overseer == null && requestModel.student ==null) ...[
              Container(
                color: Colors.white,
                height: 1,
              ),
              SizedBox(height: 5,),
              Center(
                child: Text("يتعين عليك تعيين مشرف!" , style: TextStyle(color: Colors.red),)
              ),
            ],
          ],
        ),
      ),
    );
  }
}
