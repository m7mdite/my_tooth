import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_request_controller.dart';

import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';

class ViewTreatmentsPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();
  ViewTreatmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "عرض المعالجات",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getAllTreatments();
        },
        child: GetBuilder<AdminRequestControllerImpl>(builder: (controller) {
          return ListView.separated(
            itemCount: controller.treatments.length,
            separatorBuilder: (context, index) {
              return Divider(endIndent: 50,indent: 50,
                color: AppColors.primary,
                thickness: 1,
              );
            },
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    "اسم المعالجة : ${controller.treatments[index].caseType!.caseType}"),
                subtitle: Text(
                    "اسم المادة : ${controller.treatments[index].courseInfo!.courseName}"),
              );
            },
          );
        }),
      ),
    );
  }
}
