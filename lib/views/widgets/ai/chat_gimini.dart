// views/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/ai_controllers/ai_chat_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import '../custom_app_bar.dart';
import '../custom_icon_app_bar.dart';
import 'chat_bubble.dart';
import 'typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AiChatController controller = Get.put(AiChatController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: "دكتور افتراضي",
        centerTitle: false,
        automaticallyImplyLeading: true,
        
        actions: [
          CustomIconAppBar(
            iconData: Icons.delete_outline,
            reverseColors: true,
            onTap: () => _showClearDialog(controller),
          ),
          
          CustomIconAppBar(
            iconData: Icons.settings_outlined,
            onTap: () => _showSettingsSheet(controller),
          ),
          
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.defaultBackgroundImage),
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

            // حقل الإدخال
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // زر الإعدادات السريعة
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: Colors.grey),
                          onPressed: () => _showQuickSettings(controller),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // حقل النص
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: controller.messageController,
                            decoration: InputDecoration(
                              hintText: 'اكتب رسالتك هنا...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => controller.sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // زر الإرسال
                      Obx(() => Container(
                            decoration: BoxDecoration(
                              gradient: controller.messageController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : LinearGradient(
                                      colors: [
                                        Colors.blue.shade600,
                                        Colors.purple.shade600
                                      ],
                                    ),
                              shape: BoxShape.circle,
                              color: controller.messageController.text
                                      .trim()
                                      .isEmpty
                                  ? Colors.grey[200]
                                  : null,
                            ),
                            child: IconButton(
                              icon: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded,
                                      color: Colors.white),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendMessage,
                            ),
                          )),
                    ],
                  ),
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
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(AiChatController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات الدكتور',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // const Text('النموذج', style: TextStyle(fontWeight: FontWeight.w600)),
            // const SizedBox(height: 8),
            // Obx(() => SegmentedButton<String>(
            //   segments: const [
            //     ButtonSegment(value: 'gemini-2.0-flash-exp', label: Text('Flash')),
            //     ButtonSegment(value: 'gemini-2.0-pro-exp', label: Text('Pro')),
            //   ],
            //   selected: {controller.selectedModel.value},
            //   onSelectionChanged: (Set<String> selection) {
            //     controller.selectedModel.value = selection.first;
            //   },
            // )),

            const SizedBox(height: 20),
            const Text('الإبداع (Temperature)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => Slider(
                  value: controller.temperature.value,
                  onChanged: (value) => controller.temperature.value = value,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: controller.temperature.value.toStringAsFixed(1),
                )),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickSettings(AiChatController controller) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('سرعة الرد'),
              subtitle: Obx(() => Slider(
                    value: controller.temperature.value,
                    onChanged: (v) => controller.temperature.value = v,
                    min: 0,
                    max: 1,
                  )),
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('مسح المحادثة'),
              onTap: () {
                Get.back();
                _showClearDialog(controller);
              },
            ),
          ],
        ),
      ),
    );
  }
}
