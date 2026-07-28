import 'package:get/get.dart';
import 'package:gr_flutter/models/posts_models/post_model.dart';
import 'package:gr_flutter/services/remote/public_remotes/post_remote.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

import '../../models/posts_models/comment_model.dart';
import '../../services/functions/handling_data.dart';

class PostController extends GetxController {
  final PostRemote remote = PostRemote(Get.find());
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<PostModel> pendingPosts = <PostModel>[].obs;
  RxBool isLoadingPending = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMore = true.obs;
  RxBool isLoadingMore = false.obs;
  String? currentFilter; // يمكنك لاحقاً ربطها بواجهة فلترة
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts(refresh: true);
    // fetchPosts();
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      posts.clear();
      hasMore.value = true;
      isLoadingMore.value = false;
    }
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    statusRequest.value = StatusRequest.loading;
    update();

    final response = await remote.getAllPosts(
      page: currentPage.value,
      limit: 10,
      filter: currentFilter,
    );

    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success) {
      final List<dynamic> data = response['data'] ?? [];
      final newPosts = data.map((json) => PostModel.fromJson(json)).toList();

      if (refresh) {
        posts.value = newPosts;
      } else {
        posts.addAll(newPosts);
      }
      totalPages.value = response['pagination']['total_pages'] ?? 1;
      hasMore.value = currentPage.value < totalPages.value;
      if (hasMore.value) currentPage.value++;
      posts.refresh();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البوستات');
    }
    isLoadingMore.value = false;
    statusRequest.value = StatusRequest.success;
    update();
  }

  Future<void> loadMorePosts() async {
    if (hasMore.value && !isLoadingMore.value) {
      await fetchPosts(refresh: false);
    }
  }

  void setFilter(String? filter) {
    currentFilter = filter;
    fetchPosts(refresh: true);
  }

  // Future<void> fetchPosts() async {
  //   isLoading.value = true;
  //   statusRequest.value = StatusRequest.loading;
  //   var response = await remote.getAllPosts();
  //   statusRequest.value = handlingData(response);
  //   if (statusRequest.value == StatusRequest.success) {
  //     List<dynamic> data = response['data'] ?? [];
  //     posts.value = data.map((json) => PostModel.fromJson(json)).toList();
  //   } else {
  //     Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البوستات');
  //   }
  //   isLoading.value = false;

  // }

  Future<void> createPost(String content, List<String> imagePaths) async {
    isCreating.value = true;
    final response = await remote.createPost(content, imagePaths);
    if (response['status'] == 'success') {
      Get.back();
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
      int index = posts.indexWhere((p) => p.sId == postId);

      if (index != -1) {
        // استخدم update لتعديل القائمة مباشرة
        posts[index].countLikes = response['data']['count_likes'];
        posts[index].countDislikes = response['data']['count_dislikes'];
        print("+++++++${posts[index].countLikes}");
        posts.refresh(); // إعادة بناء الواجهة
      }
    }
  }

  Future<void> dislikePost(String postId) async {
    var response = await remote.dislikePost(postId);
    if (handlingData(response) == StatusRequest.success) {
      int index = posts.indexWhere((p) => p.sId == postId);
      if (index != -1) {
        // استخدم update لتعديل القائمة مباشرة
        posts[index].countLikes = response['data']['count_likes'];
        posts[index].countDislikes = response['data']['count_dislikes'];
        print("+++++++${posts[index].countLikes}");
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
      postComments.value =
          commentsJson.map((c) => CommentModel.fromJson(c)).toList();
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
        int newCount =
            response['data']['likesCount'] ?? postComments[index].likesCount;
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

  // ===== في PostController =====

// ✅ حذف المنشور
  Future<void> deletePost(String postId) async {
    isLoading.value = true;
    final response = await remote.deletePost(postId);
    if (handlingData(response) == StatusRequest.success) {
      posts.removeWhere((p) => p.sId == postId);
      posts.refresh();
      Get.snackbar('نجاح', 'تم حذف المنشور');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الحذف');
    }
    isLoading.value = false;
  }

// ✅ تعديل المنشور (سيتم استدعاؤها من شاشة التعديل)
  Future<void> updatePost({
    required String postId,
    required String newContent,
    List<String>? newImagePaths,
    List<String>? deleteImageIds,
  }) async {
    isLoading.value = true;
    final response = await remote.updatePost(
      postId: postId,
      content: newContent,
      newImagePaths: newImagePaths,
      deleteImageIds: deleteImageIds,
    );
    if (handlingData(response) == StatusRequest.success) {
      // تحديث البوست في القائمة
      final index = posts.indexWhere((p) => p.sId == postId);
      if (index != -1) {
        posts[index] = PostModel.fromJson(response['data']);
        posts.refresh();
      }
      Get.back(); // إغلاق شاشة التعديل
      Get.snackbar('نجاح', 'تم تحديث المنشور');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل التعديل');
    }
    isLoading.value = false;
  }

  Future<void> fetchPendingPosts() async {
  isLoadingPending.value = true;
  final response = await remote.getPendingPosts();
  if (response['status'] == 'success') {
    final List<dynamic> data = response['data'] ?? [];
    pendingPosts.value = data.map((json) => PostModel.fromJson(json)).toList();
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل جلب البوستات المعلقة');
  }
  isLoadingPending.value = false;
}

// ===== الموافقة على بوست معلق (للأدمن فقط) =====
Future<void> acceptPendingPost(String postId) async {
  isLoadingPending.value = true;
  final response = await remote.acceptPendingPost(postId);
  if (response['status'] == 'success') {
    pendingPosts.removeWhere((p) => p.sId == postId);
    pendingPosts.refresh();
    // تحديث قائمة البوستات الرئيسية
    await fetchPosts(refresh: true);
    Get.snackbar('نجاح', 'تم الموافقة على المنشور ونشره للعامة');
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل الموافقة على البوست');
  }
  isLoadingPending.value = false;
}
}
