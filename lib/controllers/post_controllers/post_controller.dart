import 'package:get/get.dart';
import 'package:gr_flutter/models/post_model.dart';
import 'package:gr_flutter/services/remote/post_remote.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

import '../../models/comment_model.dart';
import '../../services/functions/handling_data.dart';

class PostController extends GetxController {
  final PostRemote remote = PostRemote(Get.find());
  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    var response = await remote.getAllPosts();
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success) {
      List<dynamic> data = response['data'] ?? [];
      posts.value = data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البوستات');
    }
    isLoading.value = false;
    
  }

  Future<void> createPost(String content, List<String> imagePaths) async {
    isCreating.value = true;
    final response = await remote.createPost(content, imagePaths);
    if (response['status'] == 'success') {
      Get.back(); // العودة من شاشة الإضافة
      await fetchPosts();
      Get.snackbar('نجاح', 'تم نشر البوست بنجاح');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل النشر');
    }
    isCreating.value = false;
  }

  Future<void> likePost(String postId) async {
    var response = await remote.likePost(postId);
    print('Like Response: $response'); // طباعة الرد للتحقق
    if (handlingData(response) == StatusRequest.success) {
      // تحديث محلي (زيادة/نقصان)
      int index = posts.indexWhere((p) => p.id == postId);

      if (index != -1) {
        // استخدم update لتعديل القائمة مباشرة
        posts[index].likesCount = response['data']['count_likes'];
        posts[index].dislikesCount = response['data']['count_dislikes'];
        print("+++++++${posts[index].likesCount}");
        posts.refresh(); // إعادة بناء الواجهة
      }
    }
  }

  Future<void> dislikePost(String postId) async {
    var response = await remote.dislikePost(postId);
    if (handlingData(response) == StatusRequest.success) {
      int index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        // استخدم update لتعديل القائمة مباشرة
        posts[index].likesCount = response['data']['count_likes'];
        posts[index].dislikesCount = response['data']['count_dislikes'];
        print("+++++++${posts[index].likesCount}");
        posts.refresh(); // إعادة بناء الواجهة
      }
    }
  }



  // أضف داخل PostController
Rx<PostModel?> selectedPost = Rx<PostModel?>(null);
RxList<CommentModel> postComments = <CommentModel>[].obs;
RxBool isLoadingDetails = false.obs;

Future<void> fetchPostDetails(String postId) async {
  isLoadingDetails.value = true;
  var response = await remote.getPostDetails(postId);
  if (response['status'] == 'success') {
    final data = response['data'];
    selectedPost.value = PostModel.fromJson(data['post']);
    List<dynamic> commentsJson = data['comments'] ?? [];
    postComments.value = commentsJson.map((c) => CommentModel.fromJson(c)).toList();
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل تفاصيل البوست');
  }
  isLoadingDetails.value = false;
}

Future<void> addComment(String postId, String content) async {
  if (content.trim().isEmpty) return;
  isLoadingDetails.value = true;
  var response = await remote.addComment(postId, content);
  if (response['status'] == 'success') {
    await fetchPostDetails(postId);
    Get.snackbar('نجاح', 'تم إضافة التعليق');
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل إضافة التعليق');
  }
  isLoadingDetails.value = false;
}

Future<void> likeComment(String commentId) async {
  var response = await remote.likeComment(commentId);
  print("$response");
  if (response['status'] == 'success') {
    int index = postComments.indexWhere((c) => c.id == commentId);
    if (index != -1) {
      int newCount = response['data']['likesCount'] ?? postComments[index].likesCount;
      postComments[index] = CommentModel(
        id: postComments[index].id,
        content: postComments[index].content,
        likesCount: newCount,
        createdAt: postComments[index].createdAt,
        user: postComments[index].user,
      );
      postComments.refresh();
    }
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل التفاعل');
  }
}

  // مساعد لمعالجة الردود (يجب إضافته إن لم يكن موجوداً)
  // StatusRequest handlingData(Map<String, dynamic> response) {
  //   if (response['status'] == 'success') return StatusRequest.success;
  //   return StatusRequest.failure;
  // }
}
