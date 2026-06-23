import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import '../../models/conversations_models/conversation_model.dart';
import '../../services/remote/public_remotes/conversations_remotes/conversation_remote.dart';
import '../../utils/app_constants/status_request.dart';

class ConversationsController extends GetxController {
  
  final ConversationRemote _conversationRemote = ConversationRemote();
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
    var response = await _conversationRemote.getUserConversations();
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

  void goToChat(String conversationId, OtherPartyProfile otherPartyProfile) {
    Get.toNamed(AppRroute.chat, arguments: {
      'conversationId': conversationId,
      'otherPartyProfile': otherPartyProfile,
    });
  }
  void openConversation(String otherUserId)async {
    statusRequest=StatusRequest.loading;
    var response =await _conversationRemote.openConversation(otherUserId);
    statusRequest= handlingData(response);
    if(statusRequest == StatusRequest.success){
      newConversation = ConversationModel.fromJson(response['data']);
      // fetchConversations();
      goToChat(newConversation!.conversationId!,newConversation!.otherPartyProfile!);
    }
  }
  Future<void> refreshConversations() async {
  await fetchConversations();
}
}