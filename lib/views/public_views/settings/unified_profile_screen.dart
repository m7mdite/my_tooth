import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../utils/app_constants/status_request.dart';
import 'unified_edit_profile_screen.dart';

class UnifiedProfileScreen extends StatelessWidget {
  final UnifiedSettingController controller = Get.find();

  UnifiedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الملف الشخصي",
        showVerifiedBadge: true,
        actions: [
          CustomIconAppBar(
            iconData: Icons.edit_outlined,
            onTap: () {
              Get.to(() => UnifiedEditProfileScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppConstants.defaultBackgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: AnimationLimiter(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // ===== الصورة الشخصية =====
                _buildAnimatedItem(
                  position: 0,
                  child: Center(
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: controller.profilePicture.value.isNotEmpty
                              ? NetworkImage("${controller.profilePicture.value}")
                              : AssetImage(AppConstants.defaultBackgroundImage) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== الاسم والدور =====
                _buildAnimatedItem(
                  position: 1,
                  child: Column(
                    children: [
                      Text(
                        controller.fullName.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade600],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          controller.getRoleTitle(),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===== معلومات الاتصال (الهاتف والبريد) =====
                _buildAnimatedItem(
                  position: 2,
                  child: _buildSectionHeader(Icons.contact_phone, 'معلومات الاتصال'),
                ),
                _buildAnimatedItem(
                  position: 3,
                  child: _buildInfoCard(
                    icon: Icons.phone,
                    label: 'رقم الهاتف',
                    value: controller.phoneNumber.value,
                    onTap: () => _copyToClipboard(controller.phoneNumber.value),
                  ),
                ),
                _buildAnimatedItem(
                  position: 4,
                  child: _buildInfoCard(
                    icon: Icons.email,
                    label: 'البريد الإلكتروني',
                    value: controller.localStorage.getEmail() ?? '',
                    onTap: () => _copyToClipboard(controller.localStorage.getEmail() ?? ''),
                  ),
                ),
                if (controller.bio.value.isNotEmpty)
                  _buildAnimatedItem(
                    position: 5,
                    child: _buildInfoCard(
                      icon: Icons.description,
                      label: 'نبذة',
                      value: controller.bio.value,
                    ),
                  ),

                // ===== بيانات المريض =====
                if (controller.role.value == 'patient') ...[
                  const SizedBox(height: 12),
                  _buildAnimatedItem(
                    position: 6,
                    child: _buildSectionHeader(Icons.health_and_safety, 'معلومات صحية'),
                  ),
                  _buildAnimatedItem(
                    position: 7,
                    child: _buildInfoCard(
                      icon: Icons.cake,
                      label: 'العمر',
                      value: '${controller.age.value} سنة',
                    ),
                  ),
                  _buildAnimatedItem(
                    position: 8,
                    child: _buildInfoCard(
                      icon: Icons.people,
                      label: 'الجنس',
                      value: controller.gender.value == 'male' ? 'ذكر' : 'أنثى',
                    ),
                  ),
                ],

                // ===== بيانات الطالب (مع فصل السنة والفئة) =====
                if (controller.role.value == 'student') ...[
                  const SizedBox(height: 12),
                  _buildAnimatedItem(
                    position: 6,
                    child: _buildSectionHeader(Icons.school, 'معلومات أكاديمية'),
                  ),
                  _buildAnimatedItem(
                    position: 7,
                    child: _buildInfoCard(
                      icon: Icons.numbers,
                      label: 'الرقم الجامعي',
                      value: controller.universityNumber.value,
                      onTap: () => _copyToClipboard(controller.universityNumber.value),
                    ),
                  ),
                  // ----- السنة (بطاقة منفصلة) -----
                  _buildAnimatedItem(
                    position: 8,
                    child: _buildInfoCard(
                      icon: Icons.calendar_month,
                      label: 'السنة الدراسية',
                      value: _getYearFromCategory(controller.category.value),
                    ),
                  ),
                  // ----- الفئة (بطاقة منفصلة) -----
                  _buildAnimatedItem(
                    position: 9,
                    child: _buildInfoCard(
                      icon: Icons.category,
                      label: 'الفئة',
                      value: _getCategoryName(controller.category.value),
                    ),
                  ),
                  _buildAnimatedItem(
                    position: 10,
                    child: _buildInfoCard(
                      icon: Icons.verified,
                      label: 'حالة التوثيق',
                      value: controller.localStorage.isVerified() ? 'موثق ✅' : 'غير موثق ❌',
                      isVerified: controller.localStorage.isVerified(),
                    ),
                  ),
                ],

                // ===== إحصائيات الحالات (للطالب والمشرف) =====
                if (controller.role.value == 'student' || controller.role.value == 'overseer') ...[
                  const SizedBox(height: 12),
                  _buildAnimatedItem(
                    position: 11,
                    child: _buildSectionHeader(Icons.assessment, 'إحصائيات الحالات'),
                  ),
                  _buildAnimatedItem(
                    position: 12,
                    child: _buildStatsRow(),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ===================== دوال تحليل الفئة =====================
  String _getYearFromCategory(String raw) {
    if (raw.isEmpty) return '';
    // محاولة استخراج الرقم الأول
    final match = RegExp(r'^(\d+)').firstMatch(raw);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  String _getCategoryName(String raw) {
    if (raw.isEmpty) return '';
    // إذا كان النص يحتوي على "." أو "_" نأخذ الجزء الثاني
    if (raw.contains('.')) {
      final parts = raw.split('.');
      if (parts.length >= 2) return parts[1].trim();
    }
    if (raw.contains('_')) {
      final parts = raw.split('_');
      if (parts.length >= 2) return parts[1].trim();
    }
    // إذا كان الرقم الأول متبوعاً بحروف (مثل "4طب_أسنان")
    final match = RegExp(r'^\d+(.*)').firstMatch(raw);
    if (match != null) {
      return match.group(1)?.trim() ?? raw;
    }
    return raw;
  }

  // ===================== أنيميشن =====================
  Widget _buildAnimatedItem({required int position, required Widget child}) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }

  // ===================== عنوان القسم =====================
  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== بطاقة معلومات عامة =====================
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isVerified = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        border: Border.all(
          color: isVerified ? Colors.green.shade300 : Colors.blueAccent.withAlpha(100),
          width: 1.5,
          strokeAlign: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isVerified ? Colors.green.shade50 : Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isVerified ? Colors.green.shade700 : Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: isVerified ? Colors.green.shade800 : Colors.black87,
                  fontSize: 14,
                  fontWeight: isVerified ? FontWeight.bold : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.copy,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===================== بطاقة الإحصائيات =====================
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(60, 10),
          bottomLeft: Radius.elliptical(10, 60),
          topRight: Radius.elliptical(10, 60),
          bottomRight: Radius.elliptical(60, 10),
        ),
        border: Border.all(color: Colors.blue.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.completedCases.value}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  'مكتملة',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pending_actions,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.inProgressCases.value}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const Text(
                  'قيد المعالجة',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== نسخ النص =====================
  void _copyToClipboard(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('تم النسخ', 'تم نسخ النص بنجاح');
  }
}
