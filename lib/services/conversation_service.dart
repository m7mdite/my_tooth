import 'package:gr_flutter/api_link.dart';
import 'crud.dart';
import 'shared/auth_model.dart';

class ConversationService {
  final Crud crud = Crud();
  final AuthModel authModel = AuthModel();

  getUserConversations() async {
    var response = await crud.getData(ApiLink.conversations, );
    return response.fold((l) => l, (r) => r);
  }
  openConversation(String otherUserId) async {
    var response = await crud.getData("${ApiLink.conversations}/$otherUserId", );
     return response.fold((l) => l, (r) => r);
  }
  // Future<Either<StatusRequest, List<ConversationModel>>> getUserConversations() async {
  //   final String? token = await authModel.getToken();
  //   if (token == null || token.isEmpty) return left(StatusRequest.unauthenticated);

  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };

  //   final result = await crud.getData(ApiLink.conversations, headers);
    
  //   return result.fold(
  //     (status) => left(status),
  //     (responseBody) {
  //       // بما أن Crud يعيد Map دائماً، نفترض أن القائمة داخل مفتاح 'data'
  //       // إذا كانت الاستجابة قائمة مباشرة، يجب تعديل Crud ليعيد dynamic
  //       if (responseBody.containsKey('data')) {
  //         final List<dynamic> data = responseBody['data'];
  //         final conversations = data.map((json) => ConversationModel.fromJson(json)).toList();
  //         return right(conversations);
  //       } else {
  //         return left(StatusRequest.serverFailure);
  //       }
  //     },
  //   );
  // }
}