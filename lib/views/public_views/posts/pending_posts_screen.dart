import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';
import '../../../app_route.dart';
import '../../../controllers/theme_controller.dart';
import '../../../services/local_storge/local_user_storage.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';

class PendingPostsScreen extends StatefulWidget {
  const PendingPostsScreen({super.key});

  @override
  State<PendingPostsScreen> createState() => _PendingPostsScreenState();
}

class _PendingPostsScreenState extends State<PendingPostsScreen> {
  final PostController controller = Get.find<PostController>();
  String currentUserRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    controller.fetchPendingPosts();
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
    final bool isAdmin = currentUserRole == 'admin';

    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            title: "المنشورات المعلقة",
            centerTitle: true,
            notifacation: false,
          ),
          body: RefreshIndicator(
            color: AppColors.primary, // ✅
            onRefresh: () => controller.fetchPendingPosts(),
            child: Obx(() {
              if (controller.isLoadingPending.value &&
                  controller.pendingPosts.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (controller.pendingPosts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_empty,
                          size: 64, color: AppColors.grey400), // ✅
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد منشورات معلقة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary, // ✅
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.pendingPosts.length,
                itemBuilder: (context, index) {
                  final post = controller.pendingPosts[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor, // ✅
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              PostCard(
                                post: post,
                                onLike: () => controller.likePost(post.sId!),
                                onDislike: () =>
                                    controller.dislikePost(post.sId!),
                                onComment: () => Get.toNamed(
                                    AppRroute.postDetail,
                                    arguments: post.sId),
                                currentUserRole: currentUserRole,
                              ),
                              // badge "قيد الانتظار"
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'قيد الانتظار',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              // زر الموافقة (للأدمن)
                              if (isAdmin)
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _showAcceptDialog(post.sId!),
                                    icon: const Icon(Icons.check_circle,
                                        size: 16),
                                    label: const Text('موافقة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  void _showAcceptDialog(String postId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface, // ✅
        title: Text(
          'تأكيد الموافقة',
          style: TextStyle(color: AppColors.textPrimary), // ✅
        ),
        content: Text(
          'هل أنت متأكد من الموافقة على هذا المنشور ونشره للعامة؟',
          style: TextStyle(color: AppColors.textSecondary), // ✅
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.acceptPendingPost(postId);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.success),
            child: const Text('موافقة'),
          ),
        ],
      ),
    );
  }
}
