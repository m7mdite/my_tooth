import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';
import 'package:gr_flutter/views/public_views/posts/create_post_screen.dart';
import 'package:gr_flutter/views/widgets/custom_photo_app_bar.dart';
import 'package:gr_flutter/views/widgets/pending_posts_button.dart';
import '../../../app_route.dart';
import '../../../services/local_storge/local_user_storage.dart';
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
    // ✅ نجيب عدد المنشورات المعلقة بدري عشان يظهر Badge زر
    // "المنشورات المعلقة" مباشرة من غير ما ينتظر المستخدم يفتح الشاشة.
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
    // ✅ التصفح اللامتناهي (Infinite scroll) خاص فقط بالفيد العام
    // المرقّم (pagination)؛ "منشوراتي" بترجع كلها دفعة وحدة من الباك.
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
    return Scaffold(
      appBar: CustomAppBar(
        leading: CustomPhotoAppBar(pic: profilePic.profilePicture.value),
        title: "المنشورات",
        centerTitle: true,
        automaticallyImplyLeading: false,
        notifacation: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          // زر إنشاء منشور (مع أنيميشن)
          AnimationConfiguration.staggeredList(
            position: 10,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: -50,
              curve: Curves.easeIn,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () => Get.to(() => CreatePostScreen()),
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "images/images_asnan/afeb34f1-66ab-49ac-a13a-e92af739f8e3.jpeg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                      border: Border(
                        right: BorderSide(color: AppColors.success),
                        bottom: BorderSide(color: AppColors.success),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "إنشاء منشور",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: AppColors.white, blurRadius: 1)],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ✅ زر "المنشورات المعلقة" بتصميم منسجم مع باقي التطبيق،
          // بدل الأيقونة البسيطة السابقة، مع Badge للعدد.
          const PendingPostsButton(),
          const SizedBox(height: 16),

          // شريط الفلترة (مع أنيميشن) — صار Obx عشان تظليل الفلتر
          // المختار يتحدث تفاعلياً (بما فيه فلتر "منشوراتي" الجديد).
          AnimationConfiguration.staggeredList(
            position: 1,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: SizedBox(
                  height: 48,
                  child: Obx(
                    () {
                      // ✅ لازم القراءة تصير هون مباشرة (متزامنة جوا
                      // builder تبع Obx)، مو جوا itemBuilder، لأنه
                      // itemBuilder بيتنفذ لاحقاً وقت الـ layout —
                      // فـ Obx ما بيقدر يسجله كـ observable ويطلع خطأ
                      // "improper use of GetX".
                      final selectedFilter = controller.currentFilter.value;

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filterOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final option = filterOptions[index];
                          final isSelected = selectedFilter == option.value;
                          return FilterChip(
                            label: Text(option.label),
                            selected: isSelected,
                            onSelected: (_) =>
                                controller.setFilter(option.value),
                            backgroundColor: AppColors.grey.shade100,
                            selectedColor: AppColors.primary100,
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primary800
                                  : AppColors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.transparent,
                                  width: 1.5),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // قائمة البوستات (مع أنيميشن لكل بوست)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.currentFilter.value == 'me'
                  ? controller.fetchMyPosts()
                  : controller.fetchPosts(refresh: true),
              child: Obx(() {
                final bool isMyPosts = controller.currentFilter.value == 'me';

                // ===== وضع "منشوراتي" =====
                if (isMyPosts) {
                  if (controller.isLoadingMy.value &&
                      controller.myPosts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.myPosts.isEmpty) {
                    return const Center(
                        child: Text('لسا ما نشرت أي منشور حتى الآن'));
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
                              onLike: () => controller.likePost(post.sId!),
                              onDislike: () =>
                                  controller.dislikePost(post.sId!),
                              onComment: () => Get.toNamed(
                                  AppRroute.postDetail,
                                  arguments: post.sId),
                              onEdit: () {
                                Get.to(() => EditPostScreen(post: post));
                              },
                              onDelete: () => controller.deletePost(post.sId!),
                              currentUserRole: currentUserRole,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                // ===== وضع الفيد العام (مع pagination) =====
                if (controller.isLoadingMore.value && controller.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.posts.isEmpty) {
                  return const Center(
                      child: Text('لا توجد بوستات بعد، كن أول من ينشر!'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: controller.posts.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
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
                            onDislike: () => controller.dislikePost(post.sId!),
                            onComment: () => Get.toNamed(AppRroute.postDetail,
                                arguments: post.sId),
                            onEdit: () {
                              Get.to(() => EditPostScreen(post: post));
                            },
                            onDelete: () => controller.deletePost(post.sId!),
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
    );
  }
}

class FilterOption {
  final String label;
  final String? value;
  FilterOption({required this.label, this.value});
}
