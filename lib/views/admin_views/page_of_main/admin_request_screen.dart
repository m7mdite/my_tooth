import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';

class AdminRequestScreen extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.put(AdminRequestControllerImpl());

  AdminRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: " إداراة الطلبات",automaticallyImplyLeading: false,),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.onInit();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("المعالجات", Icons.medical_services),
              const SizedBox(height: 12),
              _buildTwoCardsGrid(
                first: _buildCard(
                  title: "عرض المعالجات",
                  icon: Icons.visibility,
                  color: Colors.teal,
                  onTap: () => controller.toViewTreatmentsPage(),
                ),
                second: _buildCard(
                  title: "إضافة معالجة",
                  icon: Icons.add,
                  color: AppColors.success,
                  onTap: () => controller.toAddTreatmentPage(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("المواد الدراسية", Icons.book),
              const SizedBox(height: 12),
              _buildTwoCardsGrid(
                first: _buildCard(
                  title: "عرض المواد",
                  icon: Icons.visibility,
                  color: AppColors.indigo,
                  onTap: () => controller.toViewCoursesPage(),
                ),
                second: _buildCard(
                  title: "إضافة مادة",
                  icon: Icons.add,
                  color: AppColors.primary,
                  onTap: () => controller.toAddCoursePage(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("الدروس", Icons.video_library),
              const SizedBox(height: 12),
              _buildTwoCardsGrid(
                first: _buildCard(
                  title: "    إضافة درس    ",
                  icon: Icons.add,
                  color: AppColors.warning,
                  onTap: () => controller.toAddLessonsPage(),
                  fullWidth: true,
                ),
                second: _buildCard(
                  title: "عرض البرنامج ",
                  icon: Icons.visibility,
                  color: AppColors.warning,
                  onTap: () => controller.toViewLessons(),
                  fullWidth: true,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("الفئات", Icons.category),
              const SizedBox(height: 12),
              _buildTwoCardsGrid(
                first: _buildCard(
                  title: "عرض الفئات",
                  icon: Icons.visibility,
                  color: AppColors.purple,
                  onTap: () => controller.toViewCategorysPage(),
                ),
                second: _buildCard(
                  title: "إضافة فئة",
                  icon: Icons.add,
                  color: AppColors.deepPurple,
                  onTap: () => controller.toAddCategoryPage(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("الطلبات", Icons.request_page),
              const SizedBox(height: 12),
              _buildGridFourCards(
                cards: [
                  _buildCard(
                    title: "قيد الانتظار",
                    icon: Icons.hourglass_empty,
                    color: AppColors.warning,
                    onTap: () => controller.toViewPendingRequestsPage(),
                  ),
                  _buildCard(
                    title: "قيد المعالجة",
                    icon: Icons.settings,
                    color: AppColors.primary,
                    onTap: () => controller.toViewInProcessingRequestsPage(),
                  ),
                  _buildCard(
                    title: "المكتملة",
                    icon: Icons.check_circle,
                    color: AppColors.success,
                    onTap: () => controller.toViewFinishedRequestsPage(),
                  ),
                  _buildCard(
                    title: "المرفوضة",
                    icon: Icons.cancel,
                    color: AppColors.error,
                    onTap: () => controller.toViewRejectedRequestsPage(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 28),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTwoCardsGrid({required Widget first, required Widget second}) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildGridFourCards({required List<Widget> cards}) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: cards,
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
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
              colors: [color.withValues(alpha: 0.8), color],
            ),
          ),
          // إزالة الارتفاع الثابت للبطاقات ذات العرض الكامل
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: AppColors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
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
