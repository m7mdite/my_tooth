import 'package:gr_flutter/api_link.dart';
import '../../crud.dart';

class ConversationRemote {
  final Crud crud = Crud();

  getUserConversations() async {
    var response = await crud.getData(ApiLink.conversations, );
    return response.fold((l) => l, (r) => r);
  }
  openConversation(String otherUserId) async {
    var response = await crud.getData("${ApiLink.conversations}/$otherUserId", );
     return response.fold((l) => l, (r) => r);
  }
}