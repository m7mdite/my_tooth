import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/views/widgets/requests/show_request.dart';

import '../../controllers/overseer_controllers/overseer_requests_controller.dart';
import '../../models/requests_models/treatment_request_model.dart';
import '../../utils/app_constants/colors_constant.dart';

class OverseerViewRequestProcessing extends StatelessWidget {
  final OverseerRequestsControllerImpl controller =
      Get.put(OverseerRequestsControllerImpl());
  final TreatmentRequestModel requestModel;
  OverseerViewRequestProcessing({super.key, required this.requestModel});

  @override
  Widget build(BuildContext context) {
    return ShowRequest(
      requestModel: requestModel,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          // height: 50,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: const Color.fromARGB(159, 158, 158, 158), blurRadius: 5, spreadRadius: 8)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottonContainer(
                body: "رفض",
                color: AppColors.error,
                onTap: () {
                  controller.toRejectRequest(requestModel);
                },
              ),
              BottonContainer(body: "إدارة",onTap: () {
                controller.toManageRequest(requestModel);
              },),
            ],
          ),
        )
      ],
    );
  }
}
