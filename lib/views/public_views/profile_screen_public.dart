import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/controllers/conversations_controllers/conversations_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/dialog/report_user_dialog.dart';

class PublicProfileScreen extends StatelessWidget {
  final String userId;
  const PublicProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final PublicController controller = Get.find<PublicController>();
    final ConversationsController convController = Get.find<ConversationsController>();

    if (controller.otherProfile == null || controller.otherProfile!.user != userId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getOtherProfile(userId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.getOtherProfile(userId),
          child: GetBuilder<PublicController>(
            builder: (ctrl) {
              final profile = ctrl.otherProfile;
              final status = ctrl.statusRequest;

              if (status == StatusRequest.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (profile == null) {
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: AppColors.grey400),
                        const SizedBox(height: 16),
                        Text('حدث خطأ أثناء تحميل الملف الشخصي', style: TextStyle(color: AppColors.grey[600])),
                      ],
                    ),
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  // AppBar مرن (يختفي عند التمرير)
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.black87,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.black87),
                      onPressed: () => Get.back(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: AppColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(flex: 2),
                            // الصورة الشخصية مع تأثير Hero
                            Hero(
                              tag: 'profile_${profile.user}',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: AppColors.black12, blurRadius: 12, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: AppColors.grey200,
                                  backgroundImage: (profile.profilePhoto != null && profile.profilePhoto!.url!.isNotEmpty)
                                      ? NetworkImage("${profile.profilePhoto!.url}")
                                      : const AssetImage(AppConstants.defaultBackgroundImage) as ImageProvider,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${profile.firstName} ${profile.fatherName} ${profile.lastName}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black87),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getRoleTitle(profile.role??""),
                                style: TextStyle(color: AppColors.primary700, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // محتوى الصفحة (معلومات إضافية)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // أزرار مراسلة وإبلاغ
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => convController.openConversation(profile.user??""),
                                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                    label: const Text('مراسلة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => Get.dialog(ReportUserDialog(reportedUserId: profile.user!)),
                                    icon: const Icon(Icons.flag_outlined, size: 18),
                                    label: const Text('إبلاغ'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                      side: const BorderSide(color: AppColors.error),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // معلومات الاتصال
                            if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) ...[
                              _sectionTitle('معلومات الاتصال'),
                              const SizedBox(height: 8),
                              _infoCard([
                                _infoTile(Icons.phone_outlined, profile.phoneNumber!, () => _copyToClipboard(profile.phoneNumber!)),
                              ]),
                              const SizedBox(height: 24),
                            ],
                            // معلومات أكاديمية (للطالب)
                            if (profile.role == 'student') ...[
                              _sectionTitle('معلومات أكاديمية'),
                              const SizedBox(height: 8),
                              _infoCard([
                                if (profile.universityNumber != null && profile.universityNumber!.isNotEmpty)
                                  _infoTile(Icons.badge_outlined, 'الرقم الجامعي: ${profile.universityNumber}', () => _copyToClipboard(profile.universityNumber!)),
                                if (profile.category != null && profile.category!.category != null) ...[
                                  _infoTile(Icons.calendar_today_outlined, 'السنة: ${_extractYear(profile.category!.category!)}'),
                                  _infoTile(Icons.group_outlined, 'الفئة: ${_extractSpecialty(profile.category!.category!)}'),
                                ],
                              ]),
                              const SizedBox(height: 24),
                            ],
                            // معلومات صحية (للمريض)
                            if (profile.role == 'patient') ...[
                              _sectionTitle('معلومات صحية'),
                              const SizedBox(height: 8),
                              _infoCard([
                                if (profile.phoneNumber != null) _infoTile(Icons.cake_outlined, 'رقم الجوال: ${profile.phoneNumber} '),
                                if (profile.gender != null && profile.gender!.isNotEmpty)
                                  _infoTile(Icons.people_outline, 'الجنس: ${profile.gender == 'male' ? 'ذكر' : 'أنثى'}'),
                              ]),
                              const SizedBox(height: 24),
                            ],
                            // السيرة الذاتية
                            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                              _sectionTitle('نبذة'),
                              const SizedBox(height: 8),
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                color: AppColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    profile.bio!,
                                    style: const TextStyle(fontSize: 15, height: 1.4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black87),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoTile(IconData icon, String text, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary700, size: 24),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: onTap != null ? Icon(Icons.copy, size: 18, color: AppColors.grey[500]) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  String _getRoleTitle(String role) {
    switch (role) {
      case 'student': return 'طالب';
      case 'patient': return 'مريض';
      case 'overseer': return 'مشرف';
      default: return role;
    }
  }

  String _extractYear(String categoryString) {
    final match = RegExp(r'^\d+').firstMatch(categoryString);
    if (match != null) return 'السنة ${match.group(0)}';
    return 'غير محدد';
  }

  String _extractSpecialty(String categoryString) {
    String specialty = categoryString.replaceFirst(RegExp(r'^\d+'), '').replaceFirst('_', '').trim();
    return specialty.isNotEmpty ? specialty : 'عام';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('تم النسخ', 'تم نسخ النص بنجاح', snackPosition: SnackPosition.BOTTOM);
  }
}