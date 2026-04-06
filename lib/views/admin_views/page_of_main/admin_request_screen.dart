import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controller/admin_request_controller.dart';

class AdminRequestScreen extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.put(AdminRequestControllerImpl());

  AdminRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        const Text('قسم المعالجات'),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            // controller.getAllTreatments();
            controller.toViewTreatmentsPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" عرض المعالجات "),
              Icon(Icons.visibility),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.toAddTreatmentPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" إضافة معالجة "),
              Icon(Icons.add),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        const Text('قسم المواد'),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.toAddCoursePage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" إضافة مادة"),
              Icon(Icons.add),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" عرض المواد"),
              Icon(Icons.visibility),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        const Text('قسم الطلبات'),
      ],
    );
  }
}
