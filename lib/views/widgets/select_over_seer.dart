import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controller/student_requests_controller.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';

import '../patient_views/modified_request.dart';

class SelectOverSeer extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.find<StudentRequestsControllerImp>();
  final void Function()? onTap;
  SelectOverSeer({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          width: Get.width * 0.7,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 255, 255, 255),
                border: Border.all(width: 3.5, color: Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
              ),
          child: Container(
            decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.linearToSrgbGamma(),
                      opacity: 0.8,
                    ),
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("اختر احد المشرفين"),
                SizedBox(
                  height: 20,
                ),
                // SelectFromItems(
                //   items: (controller.overseersCourse)
                //       .map((o) => "${o['first_name']} ${o['last_name']}")
                //       .toList(),
                //   value: controller.overseersCourse[0]['user'],
                //   title: "اختر المشرف",
                //   onChanged: (value) {
                //     controller.hall = value!;
                //     controller.update();
                //   },
                // ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("حدد المشرف   "),
                    DropdownButton<String>(
                      hint: Text("حدد المشرف"),
                      value: controller.selectOverseer == ""
                          ? null
                          : controller.selectOverseer,
                      items: controller.overseersCourse!.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['user'],
                          child: Text("${item['first_name']} ${item['last_name']}"),
                        );
                      }).toList(),
                      focusColor: const Color.fromARGB(45, 158, 158, 158),
                      borderRadius: BorderRadius.circular(30),
                      onChanged: (newId) {
                        if (newId != null) {
                          controller.selectOverseer = newId;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                BottomContainer(
                  body: "تأكيد",
                  onTap: () {
                    onTap!();
                  },
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
