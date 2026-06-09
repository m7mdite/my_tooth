import 'package:get/get.dart';
import 'package:gr_flutter/models/posts_models/comment_model.dart';
import 'package:gr_flutter/services/remote/public_remotes/comment_remote.dart';

class CommentController extends GetxController {
  final CommentRemote remote = CommentRemote(Get.find());
  RxList<CommentModel> comments = <CommentModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchComments(String postId) async {
    isLoading.value = true;
    var response = await remote.getCommentsByPost(postId);
    if (response['status'] == 'success') {
      List<dynamic> data = response['data'] ?? [];
      comments.value = data.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل التعليقات');
    }
    isLoading.value = false;
  }

  Future<void> addComment(String postId, String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة تعليق');
      return;
    }
    isLoading.value = true;
    var response = await remote.addComment(postId, content);
    if (response['status'] == 'success') {
      await fetchComments(postId);
      Get.snackbar('نجاح', 'تم إضافة التعليق');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الإضافة');
    }
    isLoading.value = false;
  }
}