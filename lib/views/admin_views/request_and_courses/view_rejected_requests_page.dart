import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/requests/card_request_processing.dart';
import '../../widgets/requests/show_request.dart';

class ViewRejectedRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
   ViewRejectedRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الطلبات المرفوضة",
      ),
      body:  GetBuilder<AdminRequestControllerImpl>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getAllRejectedRequests();
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              return CardRequestProcessing(
                requestModel: controller.rejectedRequests[index],
                onTap: () {
                  Get.dialog(ShowRequest(
                      requestModel: controller.rejectedRequests[index]));
                },
              );
            },
            itemCount: controller.rejectedRequests.length,
          ),
        );
      }),
    );
  }
}