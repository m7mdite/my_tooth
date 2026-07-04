// views/settings/unified_setting_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/default_container_profile.dart';
import 'package:gr_flutter/views/public_views/change_password_screen.dart';
import 'package:gr_flutter/views/public_views/privacy_policy_screen.dart';
import 'package:gr_flutter/views/public_views/contact_support_screen.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../services/functions/upload_picture.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../conversations_screen.dart';
import '../notifications_view.dart';

class UnifiedSettingScreen extends StatelessWidget {
  final UnifiedSettingController controller =
      Get.find<UnifiedSettingController>();
  final ImagePicker picker = ImagePicker();

  UnifiedSettingScreen({super.key});

  void _pickAndUploadImage() async {
    final File? image = await uploadPicture();
    if (image != null) {
      await controller.uploadProfilePicture(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الاعدادات",
        automaticallyImplyLeading: false,
        notifacation: false,
        showVerifiedBadge: true,
        actions: [
          CustomIconAppBar(
            iconData: Icons.chat,
            onTap: () => Get.to(() => ConversationsScreen()),
          ),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () => Get.to(() => NotificationsView()),
            reverseColors: true,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.defaultBackgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: controller.refreshProfileData,
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.fullName.value.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return AnimationLimiter(
              child: ListView(
                children: [
                  // === 1. صورة الملف الشخصي ===
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Center(
                          child: InkWell(
                            onLongPress: _pickAndUploadImage,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              padding: const EdgeInsets.all(5),
                              height: Get.width * 0.5,
                              width: Get.width * 0.5,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image:
                                      controller.profilePicture.value.isNotEmpty
                                          ? NetworkImage(
                                              controller.profilePicture.value)
                                          : AssetImage(AppConstants
                                                  .defaultBackgroundImage)
                                              as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // === 2. الاسم والدور ===
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.fullName.value,
                              style: TextStyle(color: Colors.black),
                            ),
                            if (controller.isVerified.value) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.star, color: Colors.blue, size: 20),
                            ],
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.getRoleTitle(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === 3. الملف الشخصي ===
                  _buildAnimatedItem(
                    position: 2,
                    child: Center(
                      child: DefaultContainerProfile(
                        color: Colors.blue,
                        title: "الملف الشخصي",
                        icon: Icons.person_2_sharp,
                        onTap: controller.toShowProfile,
                      ),
                    ),
                  ),

                  // === 4. طلب التوثيق (للطالب غير الموثق) ===
                  if (controller.role.value == 'student' &&
                      !controller.isVerified.value)
                    _buildAnimatedItem(
                      position: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: DefaultContainerProfile(
                              color: Colors.blue,
                              title: "طلب التوثيق",
                              icon: Icons.real_estate_agent_outlined,
                              onTap: controller.toVerifypage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                  // === 5. تغيير اللغة ===
                  _buildAnimatedItem(
                    position: 4,
                    child: Center(
                      child: DefaultContainerProfile(
                        color: Colors.blue,
                        title: "تغيير اللغة",
                        icon: Icons.language_rounded,
                        onTap: () {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === 6. سياسة الخصوصية ===
                  _buildAnimatedItem(
                    position: 5,
                    child: InkWell(
                      onTap: () => Get.to(() => PrivacyPolicyScreen()),
                      child: Center(
                        child: DefaultContainerProfile(
                          color: Colors.blue,
                          title: "سياسة الخصوصية",
                          icon: Icons.privacy_tip_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === 7. تغيير كلمة المرور ===
                  _buildAnimatedItem(
                    position: 6,
                    child: Center(
                      child: DefaultContainerProfile(
                        color: Colors.blue,
                        title: "تغيير كلمة المرور",
                        icon: Icons.lock_outline,
                        onTap: () => Get.to(() => ChangePasswordScreen()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === 8. مراسلة الدعم ===
                  _buildAnimatedItem(
                    position: 7,
                    child: InkWell(
                      onTap: () => Get.to(() => ContactSupportScreen()),
                      child: Center(
                        child: DefaultContainerProfile(
                          color: Colors.blue,
                          title: "مراسلة الدعم",
                          icon: Icons.support_agent_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === 9. تسجيل الخروج ===
                  _buildAnimatedItem(
                    position: 8,
                    child: Center(
                      child: DefaultContainerProfile(
                        color: Colors.blue,
                        title: "تسجيل الخروج",
                        icon: Icons.logout_outlined,
                        onTap: controller.confirmLogOut,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ✅ دالة مساعدة لتغليف العناصر بالأنيميشن الموحد
  Widget _buildAnimatedItem({
    required int position,
    required Widget child,
  }) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
