import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/overseer_controllers/overseer_requests_controller.dart';
import 'package:gr_flutter/models/requests_models/treatment_model.dart';

import '../auth_text_form_field.dart';

class OverseerRejectRequest extends StatelessWidget {
  final OverseerRequestsControllerImpl controller =
      Get.find<OverseerRequestsControllerImpl>();
  OverseerRejectRequest({super.key});

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
                    controller.rejectBool = false;
                    controller.update();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.ease,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "رفض نهائيا",
                          style: TextStyle(
                            fontSize: 12,
                            color: controller.rejectBool == false
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: controller.rejectBool == false
                              ? Colors.redAccent
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
                      controller.rejectBool = true;
                      controller.update();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "إجراء تغيير",
                          style: TextStyle(
                            fontSize: 12,
                            color: !controller.rejectBool
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: !controller.rejectBool
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
            controller.rejectBool == false
                ? AuthTextFormField(
                    label: "سبب الرفض",
                    textEditingController:
                        controller.textEditingControllerReject,
                  )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "الحالة الجديدة: ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton<TreatmentModel>(
                            hint: Text(controller.selectnewTreatment!.caseType != null
                                ? controller.selectnewTreatment!.caseType!.caseType ?? ''
                                : "اختر حالة"),
                            value: controller.selectnewTreatment,
                            items: controller.treatments.map(
                              (TreatmentModel treatment) {
                                return DropdownMenuItem<TreatmentModel>(
                                  value: treatment,
                                  child: Text(
                                    treatment.caseType!.caseType ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            focusColor: const Color.fromARGB(45, 158, 158, 158),
                            borderRadius: BorderRadius.circular(30),
                            onChanged: (newId) {
                              if (newId != null) {
                                controller.selectnewTreatment = newId;
                                controller.update();
                              }
                            },
                          ),
                          
                        ],
                      ),
                      AuthTextFormField(
                            label: "ملاحظة",
                            textEditingController:
                                controller.textEditingControllerNote,
                          ),
                    ],
                  ),

          ],
        );
      },
    );
  }
}
