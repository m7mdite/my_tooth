import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/api_link.dart';

class PostRemote {
  final Crud crud;
  PostRemote(this.crud);

  getAllPosts({
    int page = 1,
    int limit = 10,
    String? filter,
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
    return response.fold((l) => l, (r) => r);
  }

  createPost(String content, List<String> imagePaths) async {
    final result = await crud.postDataWithFiles(
      ApiLink.posts,
      {'content': content},
      imagePaths,
      'images',
    );
    return result.fold((l) => l, (r) => r);
  }

  likePost(String postId) async {
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
    var response = await crud.postData('${ApiLink.comments}/$postId', {
      'content': content,
    });
    return response.fold((l) => l, (r) => r);
  }

  likeComment(String commentId) async {
    var response =
        await crud.postData('${ApiLink.comments}/comments/$commentId/like', {});
    return response.fold((l) => l, (r) => r);
  }

  // ===== في PostRemote =====

  deletePost(String postId) async {
    final response = await crud.deleteData(ApiLink.posts, postId);

    return response.fold((l) => l, (r) => r);
  }

  updatePost({
    required String postId,
    required String content,
    List<String>? newImagePaths,
    List<String>? deleteImageIds,
  }) async {
    final Map<String, dynamic> data = {
      'content': content,
      'deleteImages': deleteImageIds ?? [],
    };
    final response = await crud.putDataWithFiles(
      '${ApiLink.posts}/$postId',
      data.map((k, v) => MapEntry(k, v.toString())),
      newImagePaths ?? [],
      'images',
    );

    return response.fold((l) => l, (r) => r);
  }

   getPendingPosts() async {
    final response = await crud.getData(ApiLink.getPendingPosts);
    return response.fold((l) => l, (r) => r);
  }

  // الموافقة على بوست معلق (للأدمن فقط)
   acceptPendingPost(String postId) async {
    final response = await crud.postData('${ApiLink.acceptPendingPosts}/$postId', {});
    return response.fold((l) => l, (r) => r);
  }
}
