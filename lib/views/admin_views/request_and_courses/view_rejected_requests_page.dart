import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../widgets/requests/card_request_processing.dart';
import '../../widgets/requests/show_request_processing.dart';

class ViewRejectedRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
   ViewRejectedRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الطلبات المرفوضة'),
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
                  Get.dialog(ShowRequestProcessing(
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