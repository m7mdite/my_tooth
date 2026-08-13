// views/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/ai_controllers/ai_chat_controller.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../custom_app_bar.dart';
import '../custom_icon_app_bar.dart';
import 'chat_bubble.dart';
import 'typing_indicator.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AiChatController controller = Get.find<AiChatController>();

    return Scaffold(
      backgroundColor: AppColors.grey[50],
      appBar: CustomAppBar(
        title: "المساعد الذكي",
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          CustomIconAppBar(
            iconData: Icons.delete_outline,
            reverseColors: true,
            onTap: () => _showClearDialog(controller),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.authBackground),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma()),
        ),
        child: Column(
          children: [
            // قائمة الرسائل
            Expanded(
              child: Obx(() => ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: controller.messages.length +
                        (controller.isTyping.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.messages.length &&
                          controller.isTyping.value) {
                        return const TypingIndicator();
                      }
                      final message = controller.messages[index];
                      return ChatBubble(
                        message: message,
                        onCopy: () => controller.copyMessage(message.text),
                        onRetry: message.isUser && !message.isError
                            ? () => controller.retryMessage(index)
                            : null,
                      );
                    },
                  )),
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.primary200.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // زر المرفقات (اختياري)
                    IconButton(
                      icon: Icon(
                        Icons.attach_file,
                        color: AppColors.grey.shade500,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    // حقل النص
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'رسالتك...',
                          hintStyle: TextStyle(color: AppColors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    // زر الإرسال مع خلفية دائرية
                    Obx(() => Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient:
                                controller.messageController.text.trim().isEmpty
                                    ? null
                                    : LinearGradient(
                                        colors: [
                                          AppColors.primary600,
                                          AppColors.purple.shade600
                                        ],
                                      ),
                            shape: BoxShape.circle,
                            color:
                                controller.messageController.text.trim().isEmpty
                                    ? AppColors.primary300
                                    : null,
                          ),
                          child: IconButton(
                            icon: controller.isLoading.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.white),
                                    ),
                                  )
                                : const Icon(
                                    Icons.send_rounded,
                                    color: AppColors.white,
                                    size: 22,
                                  ),
                            onPressed: controller.isLoading.value ||
                                    controller.messageController.text
                                        .trim()
                                        .isEmpty
                                ? null
                                : controller.sendMessage,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(AiChatController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل أنت متأكد من مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            child: const Text('مسح', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

}
