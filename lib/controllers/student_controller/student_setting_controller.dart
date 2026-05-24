import 'dart:io';

import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:gr_flutter/services/shared/auth_service.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';

import '../../services/functions/upload_picture.dart';
import '../../services/remote/student_remote.dart';

abstract class StudentSettingController extends GetxController {
  logOut();
  confirmLogOut();
  toProfileInfo();
  toVerifypage();
  uploadVerifyDocument();
  verifyDocument();
}

class StudentSettingControllerImp extends StudentSettingController {
  AuthModel authModel = AuthModel();
  AuthService authService =AuthService();
  File? document;
  @override
  logOut() {
    authModel.clearToken();
    authService.clearAll();
    Get.offAllNamed(AppRroute.register);
  }

  @override
  confirmLogOut() async {
    Get.dialog(
      SubmitDialog(
        title: "تسجيل الخروج",
        question: "هل أنت متأكد من رغبتك بتسجيل الخروج؟ ",
        onTapSubmit: () async {
          Get.snackbar("باي", "مع السلامة يعمري ");
          await Future.delayed(Duration(seconds: 2));
          logOut();
        },
      ),
    );
  }

  @override
  toProfileInfo() {
    Get.toNamed(AppRroute.studentProfileInfoScreen);
  }

  @override
  toVerifypage() {
    Get.toNamed(AppRroute.viewVerify);
  }

  @override
  uploadVerifyDocument() async {
    File? pickedImage = await uploadPicture();
    if (document != pickedImage) update();
    if (pickedImage != null) {
      document = pickedImage;
      update();
    }
    update();
  }

  @override
  void onClose() {
    document = null;
    super.onClose();
  }

  StudentRemote studentRemote = StudentRemote(Get.find());
  @override
  verifyDocument() async {
    if (document == null) {
      Get.snackbar("خطأ", "الرجاء تحميل صورة البطاقة الجامعية");
      return;
    }
    Get.dialog(
      SubmitDialog(
        title: "تأكيد",
        question: "هل أنت متأكد من رغبتك في تقديم طلب التوثيق؟ ",
        onTapSubmit: () async {
          await studentRemote.sendVerifyDocument(document!);

          Get.snackbar("تم", "تم تقديم طلب التوثيق بنجاح");
          await Future.delayed(Duration(seconds: 1));
          Get.close(2);
        },
      ),
    );
    // Implement the logic to send the document to the server for verification
  }
}
