import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';

import '../../../controllers/post_controllers/post_controller.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "تفاصيل المنشور",
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value &&
            controller.selectedPost.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final post = controller.selectedPost.value;
        if (post == null) return const Center(child: Text('البوست غير موجود'));
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PostCard(
                    post: post,
                    onLike: () => controller.likePost(post.sId!),
                    onDislike: () => controller.dislikePost(post.sId!),
                    onComment: null, // منع فتح الشاشة مرة أخرى
                    onEdit: () => Get.to(() => EditPostScreen(post: post)),
                    onDelete: () => controller.deletePost(post.sId!),
                    currentUserRole: currentUserRole,
                  ),
                  const Divider(thickness: 1, height: 1),
                  if (controller.postComments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text('لا توجد تعليقات بعد، كن أول من يعلق')),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.postComments.length,
                      itemBuilder: (context, index) {
                        final comment = controller.postComments[index];
                        return _buildCommentTile(comment);
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
  }

  Widget _buildCommentTile(CommentModel comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: comment.user.profilePhoto != null
            ? NetworkImage('${comment.user.profilePhoto}')
            : null,
        child: const Icon(Icons.person),
      ),
      title: Row(
        children: [
          Text(comment.user.fullName),
          if (comment.user.isVerified) ...[
            const SizedBox(width: 4),
             Icon(Icons.verified, size: 14, color: AppColors.primary),
          ],
        ],
      ),
      subtitle: Text(comment.content),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.thumb_up_outlined, size: 18),
            onPressed: () => controller.likeComment(comment.id),
          ),
          Text('${comment.likesCount}'),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.grey300, blurRadius: 2)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'اكتب تعليقاً...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon:  Icon(Icons.send, color: AppColors.primary),
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









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/post_controllers/comment_controller.dart';
// import 'package:gr_flutter/models/post_model.dart';

// class PostDetailScreen extends StatefulWidget {
//   final String postId;
//   const PostDetailScreen({super.key, required this.postId});

//   @override
//   State<PostDetailScreen> createState() => _PostDetailScreenState();
// }

// class _PostDetailScreenState extends State<PostDetailScreen> {
//   final CommentController commentController = Get.put(CommentController());
//   final TextEditingController commentTextController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     commentController.fetchComments(widget.postId);
//   }

//   void addComment() async {
//     await commentController.addComment(widget.postId, commentTextController.text);
//     commentTextController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('التعليقات'), centerTitle: true),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (commentController.isLoading.value && commentController.comments.isEmpty) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (commentController.comments.isEmpty) {
//                 return const Center(child: Text('لا توجد تعليقات بعد'));
//               }
//               return ListView.builder(
//                 itemCount: commentController.comments.length,
//                 itemBuilder: (context, index) {
//                   final comment = commentController.comments[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: comment.userInfo.profilePhoto != null
//                           ? NetworkImage('${comment.userInfo.profilePhoto}')
//                           : null,
//                       child: const Icon(Icons.person),
//                     ),
//                     title: Text(comment.userInfo.fullName),
//                     subtitle: Text(comment.content),
//                     trailing: Text(_formatDate(comment.createdAt)),
//                   );
//                 },
//               );
//             }),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: commentTextController,
//                     decoration: const InputDecoration(hintText: 'اكتب تعليقاً...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: addComment,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
//   }
// }