import 'package:flutter/material.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_users_controller.dart';

class AddOverSeerPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = AdminUsersControllerImpl();
  AddOverSeerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add OverSeer"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Add OverSeer"),
            ),
              SizedBox(
                height: 20,
              ),
            TextFormField(
              controller: controller.emailController,
              obscureText: false,
              decoration: InputDecoration(labelText: "Email",border: OutlineInputBorder(),),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(),),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: () {
              controller.addOverSeer();
            }, child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
