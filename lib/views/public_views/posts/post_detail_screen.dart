import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';

import '../../../controllers/post_controllers/post_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/posts_models/comment_model.dart';
import '../../../services/local_storge/local_user_storage.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';
import 'edit_post_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String currentUserRole = '';
  final PostController controller = Get.find();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    controller.fetchPostDetails(widget.postId);
  }

  Future<void> _loadUserRole() async {
    final storage = Get.find<LocalUserStorage>();
    final role = await storage.getRole();
    setState(() {
      currentUserRole = role ?? 'guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            title: "تفاصيل المنشور",
            centerTitle: true,
          ),
          body: Obx(() {
            if (controller.isLoadingDetails.value &&
                controller.selectedPost.value == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            final post = controller.selectedPost.value;
            if (post == null) {
              return Center(
                child: Text(
                  'البوست غير موجود',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      PostCard(
                        post: post,
                        onLike: () => controller.likePost(post.sId!),
                        onDislike: () => controller.dislikePost(post.sId!),
                        onComment: null,
                        onEdit: () => Get.to(() => EditPostScreen(post: post)),
                        onDelete: () => controller.deletePost(post.sId!),
                        currentUserRole: currentUserRole,
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: AppColors.borderColor, // ✅
                      ),
                      if (controller.postComments.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'لا توجد تعليقات بعد، كن أول من يعلق',
                              style:
                                  TextStyle(color: AppColors.textSecondary), // ✅
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.postComments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentTile(
                                controller.postComments[index]);
                          },
                        ),
                    ],
                  ),
                ),
                _buildCommentInput(),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return ListTile(
      tileColor: AppColors.surface, // ✅
      leading: CircleAvatar(
        backgroundColor: AppColors.grey200, // ✅
        backgroundImage: comment.user.profilePhoto != null
            ? NetworkImage('${comment.user.profilePhoto}')
            : null,
        child: comment.user.profilePhoto == null
            ? Icon(Icons.person, color: AppColors.textSecondary)
            : null,
      ),
      title: Row(
        children: [
          Text(
            comment.user.fullName,
            style: TextStyle(color: AppColors.textPrimary), // ✅
          ),
          if (comment.user.isVerified) ...[
            const SizedBox(width: 4),
            Icon(Icons.verified, size: 14, color: AppColors.primary),
          ],
        ],
      ),
      subtitle: Text(
        comment.content,
        style: TextStyle(color: AppColors.textSecondary), // ✅
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up_outlined,
                size: 18, color: AppColors.primary), // ✅
            onPressed: () => controller.likeComment(comment.id),
          ),
          Text(
            '${comment.likesCount}',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface, // ✅ بدل white
        border: Border(
          top: BorderSide(color: AppColors.borderColor), // ✅
        ),
        boxShadow: [
          BoxShadow(color: AppColors.borderColor, blurRadius: 2),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              style: TextStyle(color: AppColors.textPrimary), // ✅
              decoration: InputDecoration(
                hintText: 'اكتب تعليقاً...',
                hintStyle: TextStyle(color: AppColors.textSecondary), // ✅
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primary),
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                controller.addComment(widget.postId, commentController.text);
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
