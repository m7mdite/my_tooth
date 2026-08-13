import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/posts_models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gr_flutter/views/public_views/posts/post_detail_screen.dart';
import 'package:gr_flutter/views/public_views/posts/edit_post_screen.dart'; 

import '../../../services/functions/show_image_preview.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback? onComment;
  final VoidCallback? onEdit;    
  final VoidCallback? onDelete;
  final String currentUserRole;
  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onDislike,
    this.onComment,
    this.onEdit,
    this.onDelete,
    required this.currentUserRole,
  });

  @override
  Widget build(BuildContext context)  {
    final bool canEditOrDelete = (post.isForMe == true) || (currentUserRole == 'admin');
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== رأس البوست =====
            Row(
              children: [
                // صورة المستخدم (تعطيل النقر إذا كان المنشور للمستخدم نفسه)
                InkWell(
                  onTap: post.isForMe == true 
                      ? null 
                      : () {
                          showImagePreview(
                            post.publisher?.profilePhoto != null
                                ? '${post.publisher!.profilePhoto}'
                                : AppImages.authBackground,
                          );
                        },
                  child: CircleAvatar(
                    backgroundImage: post.publisher?.profilePhoto != null
                        ? NetworkImage('${post.publisher!.profilePhoto}')
                        :  AssetImage(AppImages.authBackground)
                            as ImageProvider,
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.publisher?.fullName ?? "اسم غير معروف",
                        style:  TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Text(
                        _getRoleName(post.publisherRole!),
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // إذا كان المنشور للمستخدم نفسه → عرض قائمة الإجراءات
                if (canEditOrDelete)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        // ✅ فتح شاشة التعديل
                        Get.to(() => EditPostScreen(post: post));
                      } else if (value == 'delete') {
                        // ✅ تأكيد الحذف
                        _showDeleteConfirmation(context);
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      PopupMenuItem(value: 'delete', child: Text('حذف')),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // ===== المحتوى النصي =====
            Text(post.content!, style:  TextStyle(fontSize: 15,color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            // ===== الصور =====
            if (post.images!.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.images!.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          showImagePreview('${post.images![i].url}');
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: '${post.images![i].url}',
                            fit: BoxFit.cover,
                            width: 150,
                            placeholder: (context, url) =>
                                Container(color: AppColors.grey200),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            // ===== أزرار التفاعل =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(
                  icon: Icons.thumb_up_outlined,
                  count: post.countLikes!,
                  onTap: onLike,
                  color: AppColors.primary,
                ),
                _actionButton(
                  icon: Icons.thumb_down_outlined,
                  count: post.countDislikes!,
                  onTap: onDislike,
                  color: AppColors.error,
                ),
                _actionButton(
                  icon: Icons.comment_outlined,
                  count: post.countComments!,
                  onTap: onComment ??
                      () => Get.to(() => PostDetailScreen(postId: post.sId!)),
                  color: AppColors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== دوال مساعدة =====

  Widget _actionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text('$count', style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'student':
        return 'طالب';
      case 'patient':
        return 'مريض';
      case 'overseer':
        return 'مشرف';
      case 'admin':
        return 'مدير';
      default:
        return role;
    }
  }

  // ===== تأكيد الحذف =====
  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المنشور؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}