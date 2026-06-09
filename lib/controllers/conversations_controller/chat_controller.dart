import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/conversations_models/message_model.dart';
import '../../services/remote/public_remotes/conversations_remotes/chat_remote.dart';
import '../../services/notification/websocket_service.dart';

class ChatController extends GetxController {
  final String conversationId;
  final String otherUserId;
  final ChatRemote _chatRemote = ChatRemote();
  final WebSocketService _webSocketService = Get.find<WebSocketService>();

  RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  ChatController({required this.conversationId, required this.otherUserId});
  late StatusRequest statusRequest;
  @override
  void onInit() {
    super.onInit();
    // scrollController = scrollController.jumpTo(scrollController.position.maxScrollExtent);
    fetchMessages(otherUserId);
    _listenForNewMessages();
  }

  Future<void> fetchMessages(String otherUserId) async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    var response = await _chatRemote.getConversationMessages(otherUserId);
    print("++++++++++$response");
    handlingData(response);
    // if (statusRequest == StatusRequest.success) {
    print("5555555555");
    messages.value = (response['data']['messages'] as List)
        .map((item) => MessageModel.fromJson(item))
        .toList();
    // }
    messages.value =messages.reversed.toList();
    // print("$messages");
    // final result = await _chatService.getConversationMessages();
    // result.fold(
    //   (status) => Get.snackbar('خطأ', 'فشل تحميل الرسائل'),
    //   (msgList) => messages.assignAll(msgList),
    // );
    isLoading.value = false;
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void _listenForNewMessages() {
    _webSocketService.onNewMessage.listen(
      (messageData) {
        if (messageData['conversationId'] == conversationId) {
          messages.insert(
            0,
            MessageModel(
              id: messageData['_id'] ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              // conversationId: messageData['conversationId'],
              sender: messageData['sender'],
              content: messageData['content'] ?? '',
              messageType: messageData['message_type'] ?? 'text',
              isRead: false,
              createdAt: DateTime.now(),
              isFromMe: false,
            ),
          );
        }
      },
    );
        // scrollController.jumpTo(scrollController.position.maxScrollExtent);

  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();

    final result = await _chatRemote.sendTextMessage(conversationId, text);
    result.fold(
      (status) => Get.snackbar('خطأ', 'فشل الإرسال'),
      (newMessage) => 
        messages.insert(0, newMessage),
        // scrollController.jumpTo(scrollController.position.maxScrollExtent)
      
    );
  }

  Future<void> pickAndSendImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final result = await _chatRemote.sendFileMessage(
          conversationId, File(pickedFile.path));
      result.fold(
        (status) => Get.snackbar('خطأ', 'فشل إرسال الصورة'),
        (newMessage) => messages.insert(0, newMessage),
      );
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
