import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gr_flutter/utils/app_constants/ai_constants.dart';
import '../../services/local_storge/local_user_storage.dart';
import '../../services/remote/local_ai_remote.dart';

abstract class AiChatContr extends GetxController {
  sendMessage();
  clearChat();
  copyMessage(String text);
  retryMessage(int index);
  getRoleFromLocal();
  setFirstMessag();
}

class AiChatController extends AiChatContr {
  final LocalAiRemote _aiRemote = LocalAiRemote();
  final GetStorage _chatStorage = GetStorage();

  static const String _messagesKey = 'ai_chat_messages';
  static const String _roleKey = 'ai_chat_role';

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
  final RxDouble temperature = 0.7.obs;

  // ============================================================
  // ✅ دوال التخزين المحلي
  // ============================================================

  void saveMessages() {
    try {
      final messagesJson = messages
          .map((m) => {
                'text': m.text,
                'isUser': m.isUser,
                'isError': m.isError,
                'timestamp': m.timestamp.toIso8601String(),
              })
          .toList();
      _chatStorage.write(_messagesKey, messagesJson);
      if (role != null) {
        _chatStorage.write(_roleKey, role);
      }
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  List<ChatMessage> loadMessages() {
    try {
      final messagesJson = _chatStorage.read<List>(_messagesKey);
      if (messagesJson != null && messagesJson.isNotEmpty) {
        return messagesJson
            .map((json) => ChatMessage(
                  text: json['text'] ?? '',
                  isUser: json['isUser'] ?? false,
                  isError: json['isError'] ?? false,
                  timestamp: json['timestamp'] != null
                      ? DateTime.parse(json['timestamp'])
                      : DateTime.now(),
                ))
            .toList();
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
    return [];
  }

  String? loadStoredRole() {
    return _chatStorage.read<String>(_roleKey);
  }

  void clearStoredMessages() {
    _chatStorage.remove(_messagesKey);
    _chatStorage.remove(_roleKey);
  }

  // ============================================================
  // ✅ دورة الحياة
  // ============================================================

  @override
  void onInit() async {
    super.onInit();

    // استرجاع الدور المخزن
    final storedRole = loadStoredRole();
    if (storedRole != null) {
      role = storedRole;
      print('✅ Role loaded from storage: $role');
    } else {
      await getRoleFromLocal();
    }

    setFirstMessag();

    // استرجاع الرسائل المخزنة
    final savedMessages = loadMessages();
    if (savedMessages.isNotEmpty) {
      messages.value = savedMessages;
      print('✅ Loaded ${messages.length} messages from storage');
    } else {
      addWelcomeMessage();
      saveMessages();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  void addWelcomeMessage() {
    messages.add(firstUserMessage ??
        ChatMessage(
          text: "مرحباً! كيف يمكنني مساعدتك اليوم؟",
          isUser: false,
          timestamp: DateTime.now(),
        ));
  }

  // ============================================================
  // ✅ إرسال الرسائل
  // ============================================================

  @override
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    messageController.clear();
    scrollToBottom();

    isLoading.value = true;
    isTyping.value = true;

    try {
      final response = await _aiRemote.sendMessage(
        updateMessage(userMessage.text),
      );

      messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      scrollToBottom();
    } catch (e) {
      messages.add(ChatMessage(
        text: "عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.",
        isUser: false,
        isError: true,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      isTyping.value = false;
      saveMessages(); // ✅ حفظ الرسائل
    }
  }

  // ============================================================
  // ✅ دوال أخرى
  // ============================================================

  @override
  void clearChat() {
    messages.clear();
    clearStoredMessages();
    addWelcomeMessage();
    saveMessages();
  }

  @override
  void copyMessage(String text) {
    Get.snackbar(
      'تم النسخ',
      'تم نسخ الرسالة إلى الحافظة',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  getRoleFromLocal() async {
    final storage = Get.find<LocalUserStorage>();
    role = await storage.getRole();
    role ??= "patient";
    print("Role from local storage: $role");
  }

  @override
  void setFirstMessag() {
    print("Setting first message for role: $role");
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

  @override
  void retryMessage(int index) {
    final message = messages[index];
    if (message.isUser) {
      messageController.text = message.text;
      sendMessage();
    }
  }

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
