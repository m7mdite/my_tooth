import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_users_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';

class AdminUsersScreen extends StatelessWidget {
  final AdminUsersControllerImpl controller =
      Get.put(AdminUsersControllerImpl());

  AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "إدارة المستخدمين",
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: AppColors.white,
            ),
            onPressed: () => controller.logout(),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2, // نسبة العرض إلى الارتفاع
          children: [
            _buildCard(
              title: 'إضافة مشرف',
              icon: Icons.person_add,
              color: AppColors.success,
              onTap: () => controller.toAddOverSeerPage(),
            ),
            _buildCard(
              title: 'عرض المشرفين',
              icon: Icons.people,
              color: AppColors.primary,
              onTap: () {
                controller.getAllOverSeers();
                controller.toViewOverSeersPage();
              },
            ),
            _buildCard(
              title: 'عرض الطلاب',
              icon: Icons.school,
              color: AppColors.warning,
              onTap: () {
                controller.getAllStudents();
                controller.toViewStudentsPage();
              },
            ),
            _buildCard(
              title: 'طلبات التوثيق',
              icon: Icons.verified,
              color: AppColors.purple,
              onTap: () {
                controller.getAllVerifyStudents();
                controller.toViewVerifyStudentsPage();
              },
            ),
            _buildCard(
              title: 'عرض المرضى',
              icon: Icons.health_and_safety,
              color: Colors.teal,
              onTap: () {
                controller.getAllPatientes();
                controller.toViewPatientesPage();
              },
            ),
            _buildCard(
              title: 'البلاغات',
              icon: Icons.report_problem,
              color: AppColors.error,
              onTap: () => controller.toReportsPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppColors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
