import 'dart:io';
import 'package:gr_flutter/services/crud.dart';
import 'package:gr_flutter/api_link.dart';

class PostRemote {
  final Crud crud;
  PostRemote(this.crud);

  getAllPosts() async {
    var response = await crud.getData(ApiLink.posts);
    return response.fold((l) => l, (r) => r);
  }

  createPost(String content, List<String> imagePaths) async {
    final result = await crud.postDataWithFiles(
      ApiLink.posts,
      {'content': content},
      imagePaths,
      'images',
    );
    return result.fold(
      (statusRequest) => {
        'status': 'error',
        'message': 'فشل الاتصال بالخادم، تأكد من اتصالك بالإنترنت',
        'data': null,
      },
      (responseBody) => responseBody,
    );
  }

  likePost(String postId) async {
    print('Liking post with ID: $postId'); // طباعة ID البوست للتحقق
    print('API Endpoint: ${ApiLink.posts}/$postId/like'); // طباعة الرابط للتحقق
    var response = await crud.postData('${ApiLink.posts}/$postId/like', {});
    return response.fold((l) => l, (r) => r);
  }

  dislikePost(String postId) async {
    var response = await crud.postData('${ApiLink.posts}/$postId/dislike', {});
    return response.fold((l) => l, (r) => r);
  }

   getPostDetails(String postId) async {
    var response = await crud.getData('${ApiLink.posts}/$postId');
    return response.fold((l) => l, (r) => r);
  }

  addComment(String postId, String content) async {
    print('Adding comment to post ID: $postId with content: $content'); // طباعة ID البوست والمحتوى للتحقق
    print('API Endpoint: ${ApiLink.comments}/$postId'); // طباعة الرابط للتحقق
    var response = await crud.postData('${ApiLink.comments}/$postId', {
      'content': content,
    });
    return response.fold((l) => l, (r) => r);
  }

  likeComment(String commentId) async {
    print('${ApiLink.comments}/$commentId/like');
    print(commentId);
    var response =
        await crud.postData('${ApiLink.comments}/comments/$commentId/like', {});
    return response.fold((l) => l, (r) => r);
  }
}
