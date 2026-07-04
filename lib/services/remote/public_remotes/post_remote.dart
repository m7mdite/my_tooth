import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/api_link.dart';

class PostRemote {
  final Crud crud;
  PostRemote(this.crud);

  // getAllPosts() async {
  //   var response = await crud.getData(ApiLink.posts);
  //   return response.fold((l) => l, (r) => r);
  // }
   getAllPosts({
    int page = 1,
    int limit = 10,
    String? filter,   // 'student', 'patient', 'overseer', 'admin'
    String sort = 'createdAt',
    String order = 'desc',
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': sort,
      'order': order,
    };
    if (filter != null) queryParams['filter'] = filter;

    final uri = Uri.parse(ApiLink.posts).replace(queryParameters: queryParams);
    final response = await crud.getData(uri.toString());
    return response.fold(
      (status) => {'status': 'error', 'message': 'فشل الاتصال'},
      (data) => data,
    );
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


  // ===== في PostRemote =====

 deletePost(String postId) async {
  final response = await crud.deleteData(ApiLink.posts, postId);
  // return result.fold(
  //   (status) => {'status': 'error', 'message': 'فشل الحذف'},
  //   (data) => data,
  // );
  return response.fold((l) => l, (r) => r);
}

 updatePost({
  required String postId,
  required String content,
  List<String>? newImagePaths,
  List<String>? deleteImageIds,
}) async {
  // إرسال بيانات التعديل (نص + صور جديدة + معرفات الصور المراد حذفها)
  final Map<String, dynamic> data = {
    'content': content,
    'deleteImages': deleteImageIds ?? [],
  };
  // إضافة الصور الجديدة عبر multipart
  final response = await crud.putDataWithFiles(
    '${ApiLink.posts}/$postId',
    data.map((k, v) => MapEntry(k, v.toString())),
    newImagePaths ?? [],
    'images',
  );
  // return result.fold(
  //   (status) => {'status': 'error', 'message': 'فشل التعديل'},
  //   (data) => data,
  // );

  return response.fold((l) => l, (r) => r);
}
}
