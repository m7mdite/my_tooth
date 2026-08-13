import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';
import 'package:gr_flutter/views/widgets/requests/show_request.dart';

import '../../widgets/custom_app_bar.dart';

class ViewPendingRequestsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  ViewPendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "قيد الانتظار",
      ),
      body: GetBuilder<AdminRequestControllerImpl>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getAllPendingRequests();
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardRequestProcessing(
                    requestModel: controller.pendingRequests[index],
                    onTap: () {
                      Get.dialog(
                        ShowRequest(
                          requestModel: controller.pendingRequests[index],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'تأكيد الحذف',
                            middleText: 'هل أنت متأكد من حذف هذا الطلب؟',
                            textConfirm: 'حذف',
                            textCancel: 'إلغاء',
                            onConfirm: () {
                              Get.back();
                              controller.deleteRequest(
                                  controller.pendingRequests[index].sId!);
                            },
                          );
                        },
                        child: Text('حذف'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.rejectRequest(
                            controller.pendingRequests[index].sId!,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('رفض'),
                      ),
                    ],
                  ),
                ],
              );
            },
            itemCount: controller.pendingRequests.length,
          ),
        );
      }),
    );
  }
}
