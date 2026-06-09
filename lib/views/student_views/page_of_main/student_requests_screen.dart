import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';

import '../../../controllers/student_controllers/student_requests_controller.dart';
import '../../widgets/requests/request_container.dart';

class StudentRequestsScreen extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.put(StudentRequestsControllerImp());
  StudentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentRequestsControllerImp>(
      builder: (_) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: InkWell(
            onTap: () {
              controller.showMyRequest();
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  border:
                      Border.all(width: 1, color: Colors.blue, strokeAlign: 10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(100, 10),
                    bottomLeft: Radius.elliptical(10, 100),
                    topRight: Radius.elliptical(10, 100),
                    bottomRight: Radius.elliptical(100, 10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 3,
                      spreadRadius: 3,
                    )
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.tooth),
                  Text("  طلباتي"),
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.getPendingRequests();
            },
            child: controller.requestList.isEmpty
                ? DefaultNoData()
                : ListView.builder(
                    itemCount: controller.requestList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.requestList.length) {
                        return SizedBox(
                          height: 100,
                        );
                      }
                      return RequestContainer(
                        requestModel: controller.requestList[index],
                        onTap: () {
                          controller.showRequest(controller.requestList[index]);
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
