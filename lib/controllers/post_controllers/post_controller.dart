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

  /// ✅ صار Rx بدل String? عادي — عشان تحديث الفلتر (تظليل الشريحة
  /// المختارة + التبديل بين "الكل" و"منشوراتي") يصير تفاعلي فعلياً
  /// بدون الحاجة لإعادة بناء الشاشة كاملة يدوياً.
  /// value == null → الكل، 'student'/'patient'/'overseer' → فلترة حسب
  /// الدور، 'me' → منشوراتي الشخصية (مسار مختلف تماماً بالباك).
  Rx<String?> currentFilter = Rx<String?>(null);

  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  // ===== المنشورات الشخصية (منشوراتي) =====
  RxList<PostModel> myPosts = <PostModel>[].obs;
  RxBool isLoadingMy = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts(refresh: true);
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
      filter: currentFilter.value,
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

  /// جلب المنشورات الشخصية للمستخدم الحالي (بدون pagination — الباك
  /// بيرجعها كلها دفعة وحدة عبر GET /posts/my).
  Future<void> fetchMyPosts() async {
    isLoadingMy.value = true;
    final response = await remote.getMyPosts();
    if (handlingData(response) == StatusRequest.success) {
      final List<dynamic> data = response['data'] ?? [];
      myPosts.value = data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل منشوراتك');
    }
    isLoadingMy.value = false;
  }

  /// filter == 'me' → مسار منفصل بالكامل (منشوراتي الشخصية).
  /// غير هيك → فلترة الفيد العام حسب الدور (أو 'الكل' إذا null).
  void setFilter(String? filter) {
    currentFilter.value = filter;
    if (filter == 'me') {
      fetchMyPosts();
    } else {
      fetchPosts(refresh: true);
    }
  }

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
      _updateLikeCountsEverywhere(
        postId,
        response['data']['count_likes'],
        response['data']['count_dislikes'],
      );
    }
  }

  Future<void> dislikePost(String postId) async {
    var response = await remote.dislikePost(postId);
    if (handlingData(response) == StatusRequest.success) {
      _updateLikeCountsEverywhere(
        postId,
        response['data']['count_likes'],
        response['data']['count_dislikes'],
      );
    }
  }

  /// ✅ تحديث عدّاد اللايك/الديسلايك بكل القوائم يلي ممكن يكون البوست
  /// ظاهر فيها بنفس الوقت (الفيد العام + منشوراتي)، عشان ما يصير
  /// تضارب لو المستخدم بدّل بين الفلترين لنفس البوست.
  void _updateLikeCountsEverywhere(String postId, int? likes, int? dislikes) {
    final feedIndex = posts.indexWhere((p) => p.sId == postId);
    if (feedIndex != -1) {
      posts[feedIndex].countLikes = likes;
      posts[feedIndex].countDislikes = dislikes;
      posts.refresh();
    }

    final myIndex = myPosts.indexWhere((p) => p.sId == postId);
    if (myIndex != -1) {
      myPosts[myIndex].countLikes = likes;
      myPosts[myIndex].countDislikes = dislikes;
      myPosts.refresh();
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

  // ===== حذف المنشور =====
  Future<void> deletePost(String postId) async {
    isLoading.value = true;
    final response = await remote.deletePost(postId);
    if (handlingData(response) == StatusRequest.success) {
      posts.removeWhere((p) => p.sId == postId);
      posts.refresh();
      myPosts.removeWhere((p) => p.sId == postId);
      myPosts.refresh();
      Get.snackbar('نجاح', 'تم حذف المنشور');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الحذف');
    }
    isLoading.value = false;
  }

  // ===== تعديل المنشور (سيتم استدعاؤها من شاشة التعديل) =====
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
      final updatedPost = PostModel.fromJson(response['data']);

      final feedIndex = posts.indexWhere((p) => p.sId == postId);
      if (feedIndex != -1) {
        posts[feedIndex] = updatedPost;
        posts.refresh();
      }

      final myIndex = myPosts.indexWhere((p) => p.sId == postId);
      if (myIndex != -1) {
        myPosts[myIndex] = updatedPost;
        myPosts.refresh();
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
      pendingPosts.value =
          data.map((json) => PostModel.fromJson(json)).toList();
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
