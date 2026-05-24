import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/overseer_controller/overseer_requests_controller.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';

import '../../../controllers/student_controller/student_requests_controller.dart';
import '../../widgets/default_no_data.dart';
import '../../widgets/requests/request_container.dart';

class OverseerRequestScreen extends StatelessWidget {
  final OverseerRequestsControllerImpl controller =
      Get.put(OverseerRequestsControllerImpl());
  OverseerRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.onInit();
      },
      child: GetBuilder<OverseerRequestsControllerImpl>(
        builder: (controler) {
          return controller.requestList.isEmpty
              ? DefaultNoData()
              : ListView.builder(
                  itemCount: controller.requestList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.requestList.length) {
                      return SizedBox(
                        height: 100,
                      );
                    }
                    return CardRequestProcessing(
                      requestModel: controller.requestList[index],
                      onTap: () {
                        controller.showRequest(controller.requestList[index]);
                      },
                    );
                  },
                );
        }
      ),
    );
  }
}
