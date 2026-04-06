import 'package:flutter/material.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_users_controller.dart';

class AdminUsersScreen extends StatelessWidget {
  final AdminUsersControllerImpl controller = AdminUsersControllerImpl();
  AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        InkWell(
          onTap: () {
            controller.toAddOverSeerPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" أضف مشرف"),
              Icon(Icons.add),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.getAllOverSeers();
            controller.toViewOverSeersPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" عرض المشرفين"),
              Icon(Icons.visibility),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.getAllStudents();
            controller.toViewStudentsPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" عرض الطلاب"),
              Icon(Icons.visibility),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.getAllVerifyStudents();
            controller.toViewVerifyStudentsPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" طلبات التوثيق"), 
              Icon(Icons.verified_outlined),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            controller.getAllPatientes();
            controller.toViewPatientesPage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(" عرض المرضى"),
              Icon(Icons.visibility),
            ],
          ),
        ),
      ],
    );
  }
}
