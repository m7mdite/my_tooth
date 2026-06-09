// controllers/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/ai_constants.dart';
import '../../services/remote/public_remotes/gimini_remote.dart';

abstract class AiChatContr extends GetxController {
  sendMessage();
  clearChat();
  copyMessage(String text);
  retryMessage(int index);
  getRoleFromArguments();
  setFirstMessag();
}

class AiChatController extends AiChatContr {
  final GeminiRemote _geminiRemote = GeminiRemote();

  // قائمة الرسائل
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  ChatMessage? firstUserMessage;
  String? role;
  String? userMessage;

  String updateMessage(String message) {
    if (role == "student") {
      return '''${AiConstants.dentalProfessor} $message''';
    } else if (role == "patient") {
      return '''${AiConstants.dentalDoctor} $message''';
    } else {
      return message;
    }
  }

  // متغيرات التحكم
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final ScrollController scrollController = ScrollController();

  // إعدادات المحادثة
  // final RxString selectedModel = 'gemini-2.5-flash'.obs;
  final RxDouble temperature = 0.7.obs;

  @override
  void onInit() {
    super.onInit();
    // رسالة ترحيب افتراضية
    getRoleFromArguments();
    setFirstMessag();
    addWelcomeMessage();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void addWelcomeMessage() {
    messages.add(firstUserMessage ??
        ChatMessage(
          text: "مرحباً! كيف يمكنني مساعدتك اليوم؟",
          isUser: false,
          timestamp: DateTime.now(),
        ));
  }

  // إرسال رسالة
  @override
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    // إضافة رسالة المستخدم
    final userMessage = ChatMessage(
      text: messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    messageController.clear();

    // التمرير للأسفل
    scrollToBottom();

    // إظهار مؤشر الكتابة
    isLoading.value = true;
    isTyping.value = true;

    try {
      // إرسال الطلب إلى Gemini
      final response = await _geminiRemote.sendMessage(
        updateMessage(userMessage.text),
        // model: selectedModel.value,
        // temperature: temperature.value,
      );

      // إضافة رد المساعد
      messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      scrollToBottom();
    } catch (e) {
      // رسالة خطأ
      messages.add(ChatMessage(
        text: "عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.",
        isUser: false,
        isError: true,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      isTyping.value = false;
    }
  }

  // مسح المحادثة
  @override
  void clearChat() {
    messages.clear();
    addWelcomeMessage();
  }

  // نسخ الرسالة
  @override
  void copyMessage(String text) {
    // يمكن إضافة Clipboard functionality
    Get.snackbar(
      'تم النسخ',
      'تم نسخ الرسالة إلى الحافظة',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void getRoleFromArguments() {
    final arguments = Get.arguments;
    if (arguments != null && arguments['role'] != null) {
      role = arguments['role'];
    } else {
      role = "patient"; // القيمة الافتراضية
    }
  }

  @override
  setFirstMessag() {
    if (role == "patient") {
      firstUserMessage = ChatMessage(
        text: AiConstants.helloPatient,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } else if (role == "student") {
      firstUserMessage = ChatMessage(
        text: AiConstants.helloStudent,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } else {
      firstUserMessage = ChatMessage(
        text: "مرحباً! كيف يمكنني مساعدتك اليوم؟",
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  // إعادة إرسال الرسالة
  @override
  void retryMessage(int index) {
    final message = messages[index];
    if (message.isUser) {
      messageController.text = message.text;
      sendMessage();
    }
  }

  // التمرير للأسفل
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

// نموذج الرسالة
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
    required this.timestamp,
  });
}
