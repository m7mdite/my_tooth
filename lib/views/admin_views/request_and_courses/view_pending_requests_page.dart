import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/views/widgets/requests/request_container.dart';

import '../../widgets/custom_app_bar.dart';

class ViewPendingRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =Get.find<AdminRequestControllerImpl>();
   ViewPendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: "قيد الانتظار",),
      body: GetBuilder<AdminRequestControllerImpl>(
        builder: (_) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.getAllPendingRequests();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return RequestContainer(requestModel: controller.pendingRequests[index],);
              },
              itemCount: controller.pendingRequests.length,
            ),
          );
        }
      ),
    );
  }
}
