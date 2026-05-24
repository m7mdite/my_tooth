import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import '../models/conversation_model.dart';
import '../services/conversation_service.dart';
import '../utils/app_constants/status_request.dart';

class ConversationsController extends GetxController {
  
  final ConversationService _conversationService = ConversationService();
  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
   ConversationModel? newConversation ;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  late StatusRequest statusRequest ;
  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    errorMessage.value = '';
    statusRequest=StatusRequest.loading;
    var response = await _conversationService.getUserConversations();
    statusRequest= handlingData(response);
    if(statusRequest == StatusRequest.success){
      print("$response");

      conversations.value = (response['data'] as List)
          .map((item) => ConversationModel.fromJson(item))
          .toList();
      // conversations.assignAll(response['data'] as Iterable<ConversationModel>);
    }
    isLoading.value = false;
    // final result = await _conversationService.getUserConversations();
    
    // result.fold(
    //   (status) {
    //     if (status == StatusRequest.offlinefailure) {
    //       errorMessage.value = 'لا يوجد اتصال بالإنترنت';
    //     } else if (status == StatusRequest.serverFailure) {
    //       errorMessage.value = 'خطأ في الخادم';
    //     } else if (status == StatusRequest.unauthenticated) {
    //       errorMessage.value = 'الرجاء تسجيل الدخول مرة أخرى';
    //     }
    //   },
    //   (convList) => conversations.assignAll(convList),
    // );
    
    // isLoading.value = false;
  }

  void goToChat(String conversationId, OtherPartyModel otherParty) {
    Get.toNamed(AppRroute.chat, arguments: {
      'conversationId': conversationId,
      'otherParty': otherParty,
    });
  }
  void openConversation(String otherUserId)async {
    statusRequest=StatusRequest.loading;
    var response =await _conversationService.openConversation(otherUserId);
    statusRequest= handlingData(response);
    if(statusRequest == StatusRequest.success){
      newConversation = ConversationModel.fromJson(response['data']);
      // fetchConversations();
      goToChat(newConversation!.conversationId,newConversation!.otherParty);
    }
  }
  Future<void> refreshConversations() async {
  await fetchConversations();
}
}