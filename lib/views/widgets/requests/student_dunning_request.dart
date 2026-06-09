import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controllers/student_requests_controller.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import '../botton_controller.dart';
import '../dialog/submit_dialog.dart';
import 'show_request.dart';

class StudentDunningRequest extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.put(StudentRequestsControllerImp());
  final PendingRequestModel requestModel;
  StudentDunningRequest({super.key, required this.requestModel});

  @override
  Widget build(BuildContext context) {
    return ShowRequest(
      requestModel: requestModel,
      // toothLocation: ToothConstants.toothLocationMap,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottonContainer(
                paddingVertical: 5,
                paddingHorizontal: 15,
                body: "المطالبة بالحالة",
                onTap: () {
                  // onAgreeTap!();
                  if (controller.overseersCourse.isEmpty) {
                    Get.snackbar("لا يوجد مشرفين لهذا المقرر",
                        "يرجى التواصل مع الإدارة لتعيين مشرف لهذا المقرر");
                    return;
                  }
                  Get.dialog(
                    SubmitDialog(
                      title: "تحذير مهم !",
                      question:
                          "هل أنت متأكد من رغبتك في حجز هذه الحالة ؟؟ \n عند مطالبتك بهذه الحالة فإنك تضع المسؤولية على عاتقك \n إقرأ سياسة الخصوصية ",
                      onTapSubmit: () {
                        Get.dialog(
                          StudentSelectOverseer(
                            // requestModel: requestModel,
                            onTapSubmit: () {
                              controller.agreeRequest(requestModel.sId ?? "",
                                  controller.selectOverseer);
                              Get.close(2);
                            },
                          ),
                        );
                        // Get.close(2);
                        // agreeRequest(data, id, selectOverseer);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // StudentUnderShowRequest(
        //   onAgreeTap: () {
        //     AcceptRequestModel data = AcceptRequestModel(
        //       date: DateTime.now().toString().split(' ')[0],
        //       hour: "10:00 AM",
        //       location: "Main Clinic",
        //     );
        //   },
        // )
      ],
    );
  }
}

class StudentSelectOverseer extends StatelessWidget {
  final String? title;
  final Function()? onTapSubmit;
  StudentSelectOverseer({
    super.key,
    // required this.controller,
    // required this.requestModel,
    this.title,
    this.onTapSubmit,
  });

  // final TreatmentRequestModel requestModel;
  final StudentRequestsControllerImp controller =
      Get.put(StudentRequestsControllerImp());

  @override
  Widget build(BuildContext context) {
    return SubmitDialog(
      title: title ?? "المطالبة بالحالة",
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("حدد المشرف   "),
            DropdownButton<String>(
              hint: Text("حدد المشرف"),
              value: controller.selectOverseer == ""
                  ? null
                  : controller.selectOverseer,
              items: controller.overseersCourse.map((item) {
                return DropdownMenuItem<String>(
                  value: item['user'],
                  child: Text("${item['first_name']} ${item['last_name']}"),
                );
              }).toList(),
              focusColor: const Color.fromARGB(45, 158, 158, 158),
              borderRadius: BorderRadius.circular(30),
              onChanged: (newId) {
                if (newId != null) {
                  controller.selectOverseer = newId;
                }
              },
            ),
          ],
        ),
        // SizedBox(
        //   height: 15,
        // ),
        // AuthTextFormField(
        //   label: "الساعة",
        //   textEditingController: TextEditingController(
        //     text: controller.acceptRequestModel.hour ?? "",
        //   ),
        //   onChanged: (p0) {
        //     controller.acceptRequestModel.hour = p0;
        //   },
        // ),
        // AuthTextFormField(
        //   label: "التاريخ",
        //   textEditingController: TextEditingController(
        //     text: controller.acceptRequestModel.date ?? "",
        //   ),
        //   onChanged: (p0) {
        //     controller.acceptRequestModel.date = p0;
        //   },
        // ),
        // AuthTextFormField(
        //   label: "القاعة",
        //   textEditingController: TextEditingController(
        //     text: controller.acceptRequestModel.location ?? "",
        //   ),
        //   onChanged: (p0) {
        //     controller.acceptRequestModel.location = p0;
        //   },
        // ),
      ],
      onTapSubmit: () {
        if (onTapSubmit != null) onTapSubmit!();
      },
    );
  }
}
