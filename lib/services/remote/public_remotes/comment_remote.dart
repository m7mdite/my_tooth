import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/api_link.dart';

class CommentRemote {
  final Crud crud;
  CommentRemote(this.crud);

   getCommentsByPost(String postId) async {
    var response = await crud.getData('${ApiLink.comments}?post=$postId');
    return response.fold((l) => l, (r) => r);
  }

  addComment(String postId, String content) async {
    var response = await crud.postData(ApiLink.comments, {
      'post': postId,
      'content': content,
    });
    return response.fold((l) => l, (r) => r);
  }
}