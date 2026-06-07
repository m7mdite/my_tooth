import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/posts/post_detail_screen.dart';

import '../../services/functions/show_image_preview.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback? onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onDislike,
     this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البوست: الصورة والاسم
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showImagePreview(post.publisher.profilePhoto != null
                        ? 'http://localhost:5000/${post.publisher.profilePhoto}'
                        : AppConstants.defaultBackgroundImage);
                  },
                  child: CircleAvatar(
                    backgroundImage: post.publisher.profilePhoto != null
                        ? NetworkImage('http://localhost:5000/${post.publisher.profilePhoto}')
                        : const AssetImage(AppConstants.defaultBackgroundImage) as ImageProvider,
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.publisher.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getRoleName(post.publisherRole),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  // _formatDate(post.createdAt),
                  post.createdAt,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // المحتوى النصي
            Text(post.content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            // الصور إن وجدت
            if (post.images.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.images.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          showImagePreview('http://localhost:5000${post.images[i]}');
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: 'http://localhost:5000${post.images[i]}',
                            fit: BoxFit.cover,
                            width: 150,
                            placeholder: (context, url) => Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            // أزرار التفاعل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(
                  icon: Icons.thumb_up_outlined,
                  count: post.likesCount,
                  onTap: onLike,
                  color: Colors.blue,
                ),
                _actionButton(
                  icon: Icons.thumb_down_outlined,
                  count: post.dislikesCount,
                  onTap: onDislike,
                  color: Colors.red,
                ),
                _actionButton(
                  icon: Icons.comment_outlined,
                  count: post.commentsCount,
                  onTap: onComment ?? () => Get.to(() => PostDetailScreen(postId: post.id)),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required int count, required VoidCallback onTap, required Color color}) {
    return InkWell(
      onTap: (){onTap();},
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
    return 'الآن';
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'student': return 'طالب';
      case 'patient': return 'مريض';
      case 'overseer': return 'مشرف';
      case 'admin': return 'مدير';
      default: return role;
    }
  }
}