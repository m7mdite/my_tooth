import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gr_flutter/services/local_storge/local_user_storage.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import '../../controllers/conversations_controllers/conversations_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/conversations_models/conversation_model.dart';
import '../../services/functions/show_image_preview.dart';
import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/custom_app_bar.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConversationsController());

    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            title: 'المحادثات',
            centerTitle: true,
          ),
          body: Column(
            children: [
              // ===== تايل الذكاء الاصطناعي =====
              Container(
                color: AppColors.surface, // ✅ بدل الشفاف
                child: InkWell(
                  onTap: () async {
                    final localStorage = Get.find<LocalUserStorage>();
                    final role = await localStorage.getRole();
                    Get.toNamed("/aiChat", arguments: {"role": role});
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(AppImages.authBackground),
                    ),
                    title: Text(
                      "ذكاء اصطناعي",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary, // ✅
                      ),
                    ),
                    subtitle: Text(
                      "مرحبا كيف حالك؟",
                      style: TextStyle(color: AppColors.textSecondary), // ✅
                    ),
                    trailing: Text(
                      "12:30",
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary), // ✅
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: AppColors.borderColor), // ✅

              // ===== قائمة المحادثات =====
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary, // ✅
                  onRefresh: () async {
                    controller.fetchConversations();
                  },
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      );
                    }
                    if (controller.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.refreshConversations(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary, // ✅
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (controller.conversations.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد محادثات بعد',
                          style: TextStyle(color: AppColors.textSecondary), // ✅
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: controller.conversations.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: AppColors.borderColor), // ✅
                      itemBuilder: (context, index) {
                        final conversation = controller.conversations[index];
                        return _buildConversationTile(
                            conversation, controller);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConversationTile(
      ConversationModel conversation, ConversationsController controller) {
    final other = conversation.otherPartyProfile;
    return Container(
      color: AppColors.surface, // ✅ خلفية كل تايل
      child: ListTile(
        leading: InkWell(
          onTap: () {
            if (other.profilePhoto != null &&
                other.profilePhoto!.url != null &&
                other.profilePhoto!.url!.isNotEmpty) {
              showImagePreview("${other.profilePhoto!.url}");
            }
          },
          child: _buildAvatar(other!),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                other.fullName!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary, // ✅
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildRoleChip(other.role!),
          ],
        ),
        subtitle: Text(
          conversation.lastMessage ?? 'لا توجد رسائل',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.textSecondary), // ✅
        ),
        trailing: Text(
          "",
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary), // ✅
        ),
        onTap: () =>
            controller.goToChat(conversation.conversationId!, other),
      ),
    );
  }

  Widget _buildAvatar(OtherPartyProfile other) {
    return CircleAvatar(
      backgroundColor: AppColors.primary100, // ✅ خلفية افتراضية حسب الثيم
      backgroundImage: other.profilePhoto != null &&
              other.profilePhoto!.url != null &&
              other.profilePhoto!.url != ""
          ? CachedNetworkImageProvider("${other.profilePhoto!.url}")
          : null,
      child: other.profilePhoto == null || other.profilePhoto!.url == null
          ? Text(
              other.fullName != null ? other.fullName![0] : '?',
              style: TextStyle(color: AppColors.primary700), // ✅
            )
          : null,
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    IconData icon;

    switch (role) {
      case 'student':
        color = AppColors.primary;
        icon = Icons.school;
        break;
      case 'patient':
        icon = Icons.supervised_user_circle_sharp;
        color = AppColors.success;
        break;
      case 'overseer':
        color = AppColors.warning;
        icon = Icons.health_and_safety;
        break;
      case 'admin':
        color = AppColors.error;
        icon = Icons.admin_panel_settings;
        break;
      default:
        color = AppColors.grey;
        icon = Icons.person;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
        ],
      ),
    );
  }
}