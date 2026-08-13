import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/conversations_models/conversation_model.dart';
import 'package:gr_flutter/utils/app_constants/app_images_constant.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';
import '../../controllers/conversations_controllers/chat_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/conversations_models/message_model.dart';
import '../../utils/app_constants/colors_constant.dart';
import 'profile_screen_public.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final OtherPartyProfile otherPartyProfile;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherPartyProfile,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(
        conversationId: conversationId,
        otherPartyProfile: otherPartyProfile));

    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            actions: [
              CustomIconAppBar(
                iconData: Icons.menu_outlined,
                onTap: () => Get.to(
                    () => PublicProfileScreen(userId: otherPartyProfile.userId!)),
              )
            ],
            automaticallyImplyLeading: true,
            notifacation: false,
            showVerifiedBadge: true,
            centerTitle: false,
            title: otherPartyProfile.fullName ?? "ماكو اسم",
            titleWidget: InkWell(
              onTap: () => Get.to(
                  () => PublicProfileScreen(userId: otherPartyProfile.userId!)),
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: (otherPartyProfile.profilePhoto != null &&
                            otherPartyProfile.profilePhoto!.url != null)
                        ? NetworkImage(
                                "${otherPartyProfile.profilePhoto!.url}")
                            as ImageProvider
                        : AssetImage(AppImages.authBackground),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    otherPartyProfile.fullName ?? "ماكو اسم",
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.authBackground), // ✅ ثيم-أوير
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.messages.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      );
                    }
                    if (controller.messages.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface, // ✅
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'لا توجد رسائل بعد، ابدأ المحادثة',
                            style:
                                TextStyle(color: AppColors.textSecondary), // ✅
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(controller.messages[index]);
                      },
                    );
                  }),
                ),
                _buildMessageInput(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isMe = !message.isFromMe;

    // ✅ ألوان الفقاعة حسب الثيم
    final Color myBubbleColor = AppColors.isDark
        ? AppColors.primary.withValues(alpha: 0.85)
        : const Color.fromARGB(217, 68, 137, 255);

    final Color otherBubbleColor = AppColors.isDark
        ? AppColors.surface.withValues(alpha: 0.85)
        : const Color.fromARGB(149, 255, 255, 255);

    return Row(
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(
              bottom: 12.5,
              top: 12.5,
              right: isMe ? 50 : 10,
              left: isMe ? 10 : 50,
            ),
            decoration: BoxDecoration(
              color: isMe && message.messageType == 'text'
                  ? myBubbleColor
                  : otherBubbleColor,
              border: Border.symmetric(
                vertical: BorderSide(
                  color: isMe ? AppColors.white : AppColors.primary,
                  width: 1,
                  strokeAlign: 10,
                ),
                horizontal: BorderSide(
                  color: isMe ? AppColors.white : AppColors.primary,
                  width: 1.5,
                  strokeAlign: 12,
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft:
                    !isMe ? const Radius.circular(20) : Radius.zero,
                bottomRight:
                    !isMe ? Radius.zero : const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: message.messageType == "text"
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.content,
                        style: TextStyle(
                          // ✅ النص دايماً مقروء بكل الثيمات
                          color: isMe
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe
                                  ? AppColors.white70
                                  : AppColors.textSecondary, // ✅
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Clipboard.setData(
                                ClipboardData(text: message.content)),
                            child: Icon(
                              Icons.copy,
                              size: 16,
                              color: isMe
                                  ? AppColors.white60
                                  : AppColors.textSecondary, // ✅
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(message.content),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface, // ✅ بدل white
        border: Border(
          top: BorderSide(color: AppColors.borderColor), // ✅
        ),
        boxShadow: [
          BoxShadow(color: AppColors.borderColor, blurRadius: 2),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file,
                color: AppColors.textSecondary), // ✅
            onPressed: controller.pickAndSendImage,
          ),
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              controller: controller.textController,
              style: TextStyle(color: AppColors.textPrimary), // ✅
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                hintStyle:
                    TextStyle(color: AppColors.textSecondary), // ✅
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primary),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}