import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/requests/card_request_processing.dart';
import '../../widgets/requests/show_request_processing.dart';

class ViewFinishedRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
   ViewFinishedRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الطلبات المكتملة",
      ),
      body:  GetBuilder<AdminRequestControllerImpl>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getAllFinishedRequests();
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              return CardRequestProcessing(
                requestModel: controller.finishedRequests[index],
                onTap: () {
                  Get.dialog(ShowRequestProcessing(
                      requestModel: controller.finishedRequests[index]));
                },
              );
            },
            itemCount: controller.finishedRequests.length,
          ),
        );
      }),
    );
  }
}