import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/controllers/conversations_controllers/conversations_controller.dart';
import 'package:gr_flutter/services/functions/show_image_preview.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

import '../../controllers/theme_controller.dart';
import '../../models/public_models/profile_model.dart';
import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/dialog/report_user_dialog.dart';

class ViewOtherProfile extends StatelessWidget {
  final ProfileModel? profile;
  final ConversationsController conversationsController =
      Get.put(ConversationsController());

  ViewOtherProfile({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, 
          body: GetBuilder<PublicController>(
            builder: (_) {
              return ListView(
                children: [
                  const SizedBox(height: 5),

                  // ===== صورة البروفايل =====
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (profile!.profilePhoto?.url != null &&
                            profile!.profilePhoto!.url!.isNotEmpty) {
                          showImagePreview("${profile!.profilePhoto!.url}");
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(5),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary,
                              blurRadius: 20,
                              spreadRadius: 1,
                            )
                          ],
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage(AppImages.authBackground),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: AppColors.primary, // ✅ بدل white
                            strokeAlign: 5,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: AppColors.grey200,
                          backgroundImage: (profile!.profilePhoto?.url != null &&
                                  profile!.profilePhoto!.url!.isNotEmpty)
                              ? NetworkImage("${profile!.profilePhoto!.url}")
                              : AssetImage(AppImages.authBackground)
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),

                  // ===== الاسم =====
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${profile!.firstName} ${profile!.lastName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary, // ✅
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(Icons.verified, color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ===== أزرار مراسلة وإبلاغ =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => conversationsController
                            .openConversation(profile!.user!),
                        label: const Text("مراسلة"),
                        icon: const Icon(Icons.message),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, 
                          iconColor: AppColors.white,
                          foregroundColor: AppColors.white,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          side: BorderSide(
                              color: AppColors.primary, width: 2, strokeAlign: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppThemeConstants.borderRadius,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            ReportUserDialog(reportedUserId: profile!.user!),
                            barrierDismissible: false,
                          );
                        },
                        label: const Text("إبلاغ"),
                        icon: const Icon(Icons.report),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error, // ✅
                          iconColor: AppColors.white,
                          foregroundColor: AppColors.white,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          side: BorderSide(
                              color: AppColors.error,
                              width: 2,
                              strokeAlign: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppThemeConstants.borderRadius, 
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _divider(), 

                  const SizedBox(height: 10),

                  // ===== معلومات الطالب =====
                  if (profile!.role == "student") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _infoItem(
                          icon: Icons.school,
                          label: "السنة: ",
                          value: profile!.category!.category!.substring(0, 1) == "4"
                              ? "الرابعة"
                              : profile!.category!.category!.substring(0, 1) == "5"
                                  ? "الخامسة"
                                  : "غير محدد",
                        ),
                        _verticalDivider(),
                        _infoItem(
                          icon: Icons.group,
                          label: "الفئة: ",
                          value: profile!.category!.category!.substring(2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _divider(),
                    const SizedBox(height: 10),
                  ],

                  // ===== معلومات المريض =====
                  if (profile!.role == "patient") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: _infoItem(
                            icon: Icons.phone_outlined,
                            label: "الهاتف: ",
                            value: profile!.phoneNumber ?? 'غير محدد',
                          ),
                        ),
                        _verticalDivider(),
                        _infoItem(
                          icon: Icons.people_outline,
                          label: "الجنس: ",
                          value: profile!.gender ?? 'غير محدد',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  // ===== النبذة =====
                  if (profile!.bio != null && profile!.bio!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor, // ✅ بدل white
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(1, 10),
                          topRight: Radius.elliptical(10, 1),
                          bottomLeft: Radius.elliptical(10, 1),
                          bottomRight: Radius.elliptical(1, 10),
                        ),
                        border: Border.all(
                          color: AppColors.primary, // ✅
                          width: 1,
                          strokeAlign: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "نبذة عن العضو",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary, // ✅
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile!.bio ?? 'لا يوجد نبذة',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary, // ✅ بدل grey[700]
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ✅ دالة مساعدة للـ divider الأفقي
  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: AppColors.borderColor, // ✅
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  // ✅ دالة مساعدة للـ divider الرأسي
  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.borderColor, // ✅
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  // ✅ دالة مساعدة لعناصر المعلومات
  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary, // ✅ بدل black
            ),
          ),
        ),
      ],
    );
  }
}