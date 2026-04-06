import 'dart:math';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controller/student_profile_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

class ViewVerifyPage extends StatelessWidget {
  final StudentProfileControllerImp controller =
      Get.put(StudentProfileControllerImp());
  ViewVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" طلب توثيق الحساب ")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                AppConstants.defaultBackgroundImage,
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma()),
        ),
        child: GetBuilder<StudentProfileControllerImp>(
          builder: (_) {
            return ListView(
              children: [
                SizedBox(height: 50),
                Text("قم بتحميل الوثائق المطلوبة للتوثيق:"),
                SizedBox(height: 50),
                Text("صورة البطاقة الجامعية"),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async{
                    await controller.uploadVerifyDocument();
                    controller.update();
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: DottedDecoration(
                      color: Colors.blue,
                      strokeWidth: 3,
                      dash: [10],
                      borderRadius: BorderRadius.circular(15),
                      shape: Shape.box,
                    ),
                    child:controller.document != null ? Image.file(
                      controller.document!,
                      fit: BoxFit.fill,
                    ) : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text("اضغط للتحميل", style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        
                        shadowColor: Colors.black,
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        controller.verifyDocument();
                      },
                      child: Text("طلب التوثيق",style: TextStyle(color: Colors.white), ),
                    ),
                  ],
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
