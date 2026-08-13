import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';
import 'package:gr_flutter/views/public_views/posts/create_post_screen.dart';
import 'package:gr_flutter/views/widgets/custom_photo_app_bar.dart';
import 'package:gr_flutter/views/widgets/posts/pending_posts_button.dart';
import '../../../app_route.dart';
import '../../../controllers/theme_controller.dart';
import '../../../services/local_storge/local_user_storage.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';
import 'edit_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String currentUserRole = '';
  final PostController controller = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();

  final List<FilterOption> filterOptions = [
    FilterOption(label: 'الكل', value: null),
    FilterOption(label: 'منشوراتي', value: 'me'),
    FilterOption(label: 'طلاب', value: 'student'),
    FilterOption(label: 'مرضى', value: 'patient'),
    FilterOption(label: 'مشرفين', value: 'overseer'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _scrollController.addListener(_onScroll);
    controller.fetchPendingPosts();
  }

  Future<void> _loadUserRole() async {
    final storage = Get.find<LocalUserStorage>();
    final role = await storage.getRole();
    setState(() {
      currentUserRole = role ?? 'guest';
    });
  }

  void _onScroll() {
    if (controller.currentFilter.value == 'me') return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilePic = Get.find<UnifiedSettingController>();
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            leading: CustomPhotoAppBar(pic: profilePic.profilePicture.value),
            title: "المنشورات",
            centerTitle: true,
            automaticallyImplyLeading: false,
            notifacation: true,
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      AppImages.authBackground,
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.linearToSrgbGamma())),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const PendingPostsButton(),

                    Expanded(
                      child: AnimationConfiguration.staggeredList(
                        position: 10,
                        duration: const Duration(milliseconds: 300),
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () => Get.to(() => CreatePostScreen()),
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                // ✅ خلفية الثيم بدل الصورة الثابتة
                                image: DecorationImage(
                                  image: AssetImage(AppImages.authBackground),
                                  fit: BoxFit.cover,
                                  // colorFilter: ColorFilter.linearToSrgbGamma(),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.elliptical(100, 10),
                                  bottomLeft: Radius.elliptical(10, 100),
                                  topRight: Radius.elliptical(10, 100),
                                  bottomRight: Radius.elliptical(100, 10),
                                ),
                                border: Border(
                                  right:
                                      BorderSide(color: AppColors.primary), // ✅
                                  bottom:
                                      BorderSide(color: AppColors.primary), // ✅
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "إنشاء منشور",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.black,
                                        blurRadius: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // const SizedBox(height: 16),
                  ],
                ),
                // ===== زر إنشاء منشور =====

                // ===== شريط الفلترة =====
                AnimationConfiguration.staggeredList(
                  position: 1,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: SizedBox(
                        height: 48,
                        child: Obx(() {
                          final selectedFilter = controller.currentFilter.value;
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filterOptions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final option = filterOptions[index];
                              final isSelected = selectedFilter == option.value;
                              return FilterChip(
                                label: Text(option.label),
                                selected: isSelected,
                                onSelected: (_) =>
                                    controller.setFilter(option.value),
                                backgroundColor: AppColors.cardColor, // ✅
                                selectedColor: AppColors.primary100,
                                checkmarkColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary800
                                      : AppColors.textSecondary, // ✅
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.borderColor, // ✅
                                    width: 1.5,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ===== قائمة البوستات =====
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary, // ✅
                    onRefresh: () => controller.currentFilter.value == 'me'
                        ? controller.fetchMyPosts()
                        : controller.fetchPosts(refresh: true),
                    child: Obx(() {
                      final bool isMyPosts =
                          controller.currentFilter.value == 'me';

                      if (isMyPosts) {
                        if (controller.isLoadingMy.value &&
                            controller.myPosts.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (controller.myPosts.isEmpty) {
                          return Center(
                            child: Text(
                              'لسا ما نشرت أي منشور حتى الآن',
                              style: TextStyle(
                                  color: AppColors.textSecondary), // ✅
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: controller.myPosts.length,
                          itemBuilder: (context, index) {
                            final post = controller.myPosts[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: PostCard(
                                    post: post,
                                    onLike: () =>
                                        controller.likePost(post.sId!),
                                    onDislike: () =>
                                        controller.dislikePost(post.sId!),
                                    onComment: () => Get.toNamed(
                                        AppRroute.postDetail,
                                        arguments: post.sId),
                                    onEdit: () => Get.to(
                                        () => EditPostScreen(post: post)),
                                    onDelete: () =>
                                        controller.deletePost(post.sId!),
                                    currentUserRole: currentUserRole,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      if (controller.isLoadingMore.value &&
                          controller.posts.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      if (controller.posts.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد بوستات بعد، كن أول من ينشر!',
                            style:
                                TextStyle(color: AppColors.textSecondary), // ✅
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: controller.posts.length +
                            (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.posts.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                          final post = controller.posts[index];
                          return AnimationConfiguration.staggeredList(
                            position: index + 2,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: PostCard(
                                  post: post,
                                  onLike: () => controller.likePost(post.sId!),
                                  onDislike: () =>
                                      controller.dislikePost(post.sId!),
                                  onComment: () => Get.toNamed(
                                      AppRroute.postDetail,
                                      arguments: post.sId),
                                  onEdit: () =>
                                      Get.to(() => EditPostScreen(post: post)),
                                  onDelete: () =>
                                      controller.deletePost(post.sId!),
                                  currentUserRole: currentUserRole,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FilterOption {
  final String label;
  final String? value;
  FilterOption({required this.label, this.value});
}
