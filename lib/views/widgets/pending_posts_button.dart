import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controllers/post_controller.dart';
import '../public_views/posts/pending_posts_screen.dart';

/// زر "المنشورات المعلقة" — بنفس لغة التصميم المستخدمة بباقي التطبيق
/// (شكل بيضاوي بحدود ملونة، زي زر "إنشاء منشور" وأزرار الطلبات).
/// بيعرض Badge بعدد المنشورات المعلقة لو موجودة (لسهولة الانتباه لها
/// بدون فتح الشاشة).
class PendingPostsButton extends StatelessWidget {
  const PendingPostsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();

    return InkWell(
      onTap: () => Get.to(() => const PendingPostsScreen()),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.elliptical(100, 10),
        bottomLeft: Radius.elliptical(10, 100),
        topRight: Radius.elliptical(10, 100),
        bottomRight: Radius.elliptical(100, 10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.08),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          border: const Border(
            right: BorderSide(color: Colors.orange),
            bottom: BorderSide(color: Colors.orange),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.hourglass_top, color: Colors.orange, size: 22),
                Obx(() {
                  final count = controller.pendingPosts.length;
                  if (count == 0) return const SizedBox.shrink();
                  return Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(width: 8),
            const Text(
              'المنشورات المعلقة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
