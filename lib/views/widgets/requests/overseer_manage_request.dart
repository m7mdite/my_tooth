import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/auth_text_form_field.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';

import '../../../controllers/overseer_controller/overseer_requests_controller.dart';

class OverseerManageRequest extends StatelessWidget {
  final OverseerRequestsControllerImpl controller =
      Get.find<OverseerRequestsControllerImpl>();
  OverseerManageRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverseerRequestsControllerImpl>(
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    controller.finishBool = false;
                    controller.update();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.ease,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "متابعة الحالة",
                          style: TextStyle(
                            fontSize: 12,
                            color: controller.finishBool == false
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: controller.finishBool == false
                              ? Colors.green
                              : Colors.grey,
                          width: Get.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 900),
                  curve: Curves.ease,
                  child: InkWell(
                    onTap: () {
                      controller.finishBool = true;
                      controller.update();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "إنهاء وقبول",
                          style: TextStyle(
                            fontSize: 12,
                            color: !controller.finishBool
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: !controller.finishBool
                              ? Colors.grey
                              : Colors.blue,
                          width: Get.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            controller.finishBool
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthTextFormField(
                        label: "تقييم",
                        textEditingController:
                            controller.textEditingControllerRating,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AuthTextFormField(
                        label: "ملاحظة",
                        textEditingController:
                            controller.textEditingControllerFeedback,
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.selectRequest.stageEvaluations!.isNotEmpty ) ...[
                        Center(
                          child: BottomContainer(
                            body: "عرض التقييمات السابقة",
                            fontSize: 12,
                            onTap: () {
                              Get.dialog(SubmitDialog(children: [
                                ...controller.selectRequest.stageEvaluations!.map((e) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: Text(e.text!)),
                                    SizedBox(width: 5,),
                                    Text(e.date!.split('-')[0]),
                                  ],
                                ))
                              ],),);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                      AuthTextFormField(
                        label: "إضافة تقييم مرحلي",
                        textEditingController:
                            controller.textEditingControllerAddEvaluation,
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
