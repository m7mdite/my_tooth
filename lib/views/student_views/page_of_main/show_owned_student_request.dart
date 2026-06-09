import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controllers/student_requests_controller.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';

class ShowOwnedStudentRequest extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.find<StudentRequestsControllerImp>();
  ShowOwnedStudentRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getOwnedStudentRequest();
        },
        child: GetBuilder<StudentRequestsControllerImp>(
          builder: (context) {
            return controller.requestSpecialList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.requestSpecialList.length,
                    itemBuilder: (context, index) {
                      return CardRequestProcessing(
                        requestModel: controller.requestSpecialList[index],
                        onTap: () {
                          controller.showOnedRequest(controller.requestSpecialList[index]);
                        },
                      );
                    },
                  )
                : DefaultNoData();
          }
        ),
      ),
    );
  }
}
