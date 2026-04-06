import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/auth/login_controller.dart';
import '../widgets/auth_text_form_field.dart';

class Login extends GetView<LoginControllerImp> {
  // final LoginControllerImp controller = Get.find<LoginControllerImp>();
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/images_asnan/asnan6.jpeg"),
                fit: BoxFit.cover)),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Get.width <= 400 ? 15 : (Get.width - 400) * 0.5,
              vertical: 30),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
            color: const Color.fromARGB(144, 255, 255, 255),
          ),
          child: GetBuilder<LoginControllerImp>(builder: (controller) {
            return Form(
              key: controller.formStateLogin,
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("images/images_asnan/asnan6.jpeg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(300)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "تسجيل الدخول ",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  SizedBox(height: 20),

                  // الإيميل
                  AuthTextFormField(
                    label: "الايميل",
                    textEditingController: controller.email,
                  ),

                  // كلمة المرور
                  AuthTextFormField(
                    label: "كلمة المرور",
                    textEditingController: controller.password,
                    isPassword: true,
                  ),

                  // زر التسجيل
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        controller.login();
                      },
                      child: Text(
                        "تسجيل",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("ليس لديك حساب ؟ "),
                  TextButton(
                      onPressed: () {
                          controller.goToRegister();
                        
                      },
                      child: Text("إنشاء حساب"))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
