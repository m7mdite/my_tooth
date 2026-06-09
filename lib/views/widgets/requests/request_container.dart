import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import '../../../utils/app_constants/tooth_constants.dart';

class RequestContainer extends StatelessWidget {
  final PendingRequestModel requestModel;
  final Map? toothLocation=ToothConstants.toothLocationMap;
  final void Function()? onTap;
  const RequestContainer({
    super.key,
    required this.requestModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                  toothLocation?[requestModel.requestion!.toothLocation] ?? "غير محدد",
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
                Text("نوع الحالة : "),
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
                    child: Text(
                      requestModel.caseType!.caseType??""
                      // requestModel.course!.courseName??"",
                    ),
                  ),
                ),
                // if(requestModel.overseerNote != null) ...[
                //   SizedBox(width: 5,),
                //   FaIcon(FontAwesomeIcons.squareCheck, size: 12,color: Colors.blue,)
                // ],
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  // child: Column(mainAxisSize: MainAxisSize.max,),
                ),
                Text("شدة الألم: "),
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
                            color: requestModel.requestion!.painSeverity!>=5?Colors.red:Colors.white,
                            border: Border.all(color: Colors.blue)
                            ,
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        SizedBox(width: 1,),
                      ],
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
                Text("وقت الألم: "),
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
                      requestModel.requestion!.painTime??"غير محدد",
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
                Text(
                  // requestModel.status!,
                  "",
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
                Text("",
                  // "${requestModel.updatedAt!.day}/${requestModel.updatedAt!.month}/${requestModel.updatedAt!.year}",
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
          ],
        ),
      ),
    );
  }
}
