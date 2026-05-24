import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_request_controller.dart';

class ViewTreatmentsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =Get.find<AdminRequestControllerImpl>();
   ViewTreatmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض المعالجات")),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getAllTreatments();
        },
         
        child: GetBuilder<AdminRequestControllerImpl>(
          builder: (controller) {
            return ListView.builder(
              itemCount:  controller.treatments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.treatments[index].caseType!.caseType ?? "اسم المعالجة غير متوفر"),
                  // subtitle: Text(controller.treatments[index].course!.courseName ?? "اسم الكورس غير متوفر"),
                );
              },
            );
          }
        ),
      ),
    );
  }
}