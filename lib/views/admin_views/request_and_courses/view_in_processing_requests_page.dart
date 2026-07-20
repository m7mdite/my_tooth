import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/requests/show_request_processing.dart';

import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/requests/card_request_processing.dart';

class ViewInProcessingRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  ViewInProcessingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الطلبات قيد المعالجة",
      ),  
      body: GetBuilder<AdminRequestControllerImpl>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getAllInProcessingRequests();
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              return CardRequestProcessing(
                requestModel: controller.inProcessingRequests[index],
                onTap: () {
                  Get.dialog(ShowRequestProcessing(
                      requestModel: controller.inProcessingRequests[index]));
                },
              );
            },
            itemCount: controller.inProcessingRequests.length,
          ),
        );
      }),
    );
  }
}
