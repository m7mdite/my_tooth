import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_photo_app_bar.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../../controllers/home_dashboard_controller.dart';
import '../../models/dashboard_model.dart';
import '../../services/local_storge/local_user_storage.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../admin_views/admin_notify_dialog.dart';
import '../admin_views/advertisement_management_screen.dart';
import '../widgets/dialog/submit_dialog.dart';

class HomeDashboardScreen extends StatelessWidget {
  HomeDashboardScreen({super.key});

  final HomeDashboardController controller = Get.put(HomeDashboardController());
  final UnifiedSettingController settingController =
      Get.find<UnifiedSettingController>();

  @override
  Widget build(BuildContext context) {
    String role = settingController.role.value;
    return Scaffold(
      appBar: CustomAppBar(
        title: "الرئيسية",
        actions: [
          CustomIconAppBar(
            iconData: Icons.chat,
            onTap: () async {
              final localStorage = Get.find<LocalUserStorage>();
              final String? token = await localStorage.getToken();
              if (token != null) {
                Get.toNamed(AppRroute.conversations);
              } else {
                Get.dialog(SubmitDialog(
                  title: "تنبيه",
                  question: "هذه الميزة متاحة فقط للمستخدمين المسجلين.",
                  agreeBottontitle: "تسجيل الدخول",
                  onTapSubmit: () {
                    Get.offAllNamed(AppRroute.auth);
                  },
                ));
              }
            },
          ),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () async {
              final localStorage = Get.find<LocalUserStorage>();
              final String? token = await localStorage.getToken();
              if (token != null) {
                Get.toNamed(AppRroute.notificationsView);
              } else {
                Get.dialog(SubmitDialog(
                  title: "تنبيه",
                  question: "هذه الميزة متاحة فقط للمستخدمين المسجلين.",
                  agreeBottontitle: "تسجيل الدخول",
                  onTapSubmit: () {
                    Get.offAllNamed(AppRroute.auth);
                  },
                ));
              }
            },
            reverseColors: true,
          ),
        ],
        automaticallyImplyLeading: false,
        leading: Obx(() {
          final pic = settingController.profilePicture.value;
          return InkWell(
            onTap: () async {
              final localStorage = Get.find<LocalUserStorage>();
              final String? token = await localStorage.getToken();
              if (token != null) {
                Get.toNamed(AppRroute.unifiedProfileScreen);
              } else {
                Get.dialog(SubmitDialog(
                  title: "تنبيه",
                  question: "هذه الميزة متاحة فقط للمستخدمين المسجلين.",
                  agreeBottontitle: "تسجيل الدخول",
                  onTapSubmit: () {
                    Get.offAllNamed(AppRroute.auth);
                  },
                ));
              }
            },
            child: CustomPhotoAppBar(pic: pic),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:role == "admin"? InkWell(
        onTap: () {Get.dialog(
                            const AdminNotifyDialog(),
                            barrierDismissible: false,
                          );},
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.white24,
              border: Border.all(width: 1, color: AppColors.primary, strokeAlign: 10),
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(100, 10),
                bottomLeft: Radius.elliptical(10, 100),
                topRight: Radius.elliptical(10, 100),
                bottomRight: Radius.elliptical(100, 10),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 3,
                  spreadRadius: 3,
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active),
              Text("إرسال إشعار للجميع"),
            ],
          ),
        ),
      ):null,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.onInit();
        },
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.dashboard.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.dashboard.value == null) {
            return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          }
          final dashboard = controller.dashboard.value!;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.defaultBackgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
              ),
            ),
            child: AnimationLimiter(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // ===== 1. إحصائيات الطلبات =====
                    _buildStatsSection(dashboard.requests!, role),
                    
                      
                    // ===== 2. الإعلانات (كاروسيل) =====
                    if (dashboard.adv != null &&
                        dashboard.adv!.data != null &&
                        dashboard.adv!.data!.isNotEmpty)
                      _buildAdvSection(dashboard.adv!.data!),

                    // ===== 3. أزرار التنقل =====
                    _buildQuickActions(),

                    // ===== 4. أفضل البوستات =====
                    if (dashboard.topPosts != null &&
                        dashboard.topPosts!.data != null &&
                        dashboard.topPosts!.data!.isNotEmpty)
                      _buildTopPostsSection(dashboard.topPosts!.data!),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsSection(Requests stats, String role) {
    final myCases = controller.dashboard.value?.myCases;
    final users = controller.dashboard.value?.users;
    print(role);
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary800, AppColors.primary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.primary, width: 2, strokeAlign: 10),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(80, 10),
                bottomLeft: Radius.elliptical(10, 80),
                topRight: Radius.elliptical(10, 80),
                bottomRight: Radius.elliptical(80, 10),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary300,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والإجمالي في صف واحد
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.assessment,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'طلبات العلاج',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'الإجمالي: ${stats.total ?? 0}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // الإحصائيات العامة (شبكة 3 أعمدة)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                        icon: Icons.hourglass_empty,
                        count: stats.pending ?? 0,
                        label: 'انتظار',
                        color: AppColors.warning),
                    _buildStatItem(
                        icon: Icons.settings,
                        count: stats.processing ?? 0,
                        label: 'معالجة',
                        color: AppColors.primaryLightAccent),
                    _buildStatItem(
                        icon: Icons.check_circle,
                        count: stats.finished ?? 0,
                        label: 'مكتملة',
                        color: AppColors.lightGreenAccent),
                  ],
                ),
                if (users != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: AppColors.white24,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.white60, size: 14),
                      const SizedBox(width: 6),
                      const Text(
                        'عدد المستخدمين الكلي',
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      _buildMiniStat(
                          count: users.countUsers ?? 0,
                          label: 'مستخدم',
                          color: AppColors.lightGreenAccent),
                    ],
                  ),
                ],
                // حالاتي الخاصة (إن وجدت)
                if (myCases != null && role != 'admin') ...[
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: AppColors.white24,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.white60, size: 14),
                      const SizedBox(width: 6),
                      const Text(
                        'حالاتي',
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // إحصائيات حالاتي (مضغوطة)
                      Row(
                        children: [
                          if (myCases.pending != null)
                            _buildMiniStat(
                                count: myCases.pending!,
                                label: 'انتظار',
                                color: AppColors.warning),
                          const SizedBox(width: 10),
                          _buildMiniStat(
                              count: myCases.inProcess ?? 0,
                              label: 'معالجة',
                              color: AppColors.primaryLightAccent),
                          const SizedBox(width: 10),
                          _buildMiniStat(
                              count: myCases.finished ?? 0,
                              label: 'مكتملة',
                              color: AppColors.lightGreenAccent),
                        ],
                      ),
                    ],
                  ),
                ],
                // =======================================================
              ],
            ),
          ),
        ),
      ),
    );
  }

// دالة لعنصر إحصائي فردي (شبكي)
  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 24),
        const SizedBox(height: 2),
        Text(
          count.toString(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

// دالة لعنصر إحصائي مصغر (للحالات الخاصة)
  Widget _buildMiniStat({
    required int count,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.white60,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  // ===== قسم الإعلانات (باستخدام AdvItem) =====
  Widget _buildAdvSection(List<AdvItem> advs) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 150, // زدنا الارتفاع قليلاً للراحة
                child: PageView.builder(
                  controller: controller.advPageController,
                  onPageChanged: controller.onAdvPageChanged,
                  itemCount: advs.length,
                  itemBuilder: (context, index) {
                    final adv = advs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          image: adv.image?.url != null
                              ? DecorationImage(
                                  image: NetworkImage(adv.image!.url!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: adv.image?.url == null
                              ? AppColors.primary400
                              : null,
                          borderRadius: AppThemeConstants.borderRadius,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Stack(
                          children: [
                            // ✅ نص الإعلان في الأسفل مع خلفية شفافة
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.elliptical(80, 10),
                                    bottomRight: Radius.elliptical(80, 10),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.black.withValues(alpha: 0.8),
                                      AppColors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  adv.content ?? '',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // نقاط التقدم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(advs.length, (i) {
                  return Obx(() => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: controller.currentAdvIndex.value == i ? 20 : 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: controller.currentAdvIndex.value == i
                              ? AppColors.primary
                              : AppColors.grey300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Obx(() {
              final isAdmin = controller.isAdmin.value;

              return Row(
                children: [
                  if (!isAdmin)
                    Expanded(
                      child: _actionButton(
                        icon: Icons.chat,
                        label: 'المساعد الذكي',
                        color: AppColors.success,
                        onTap: () => Get.toNamed(AppRroute.aiChat),
                      ),
                    ),
                  if (isAdmin) ...[
                    // const SizedBox(width: 16),
                    Expanded(
                      child: _actionButton(
                        icon: Icons.ad_units,
                        label: 'إدارة الإعلانات',
                        color: AppColors.purple.shade700,
                        onTap: () =>
                            Get.to(() => AdvertisementManagementScreen()),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.95),
          borderRadius: AppThemeConstants.borderRadius,
          border: Border.all(color: color, width: 1.2),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPostsSection(List<DataPost> posts) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'أفضل المنشورات',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    TextButton(
                      onPressed: () async {
                        final localStorage = Get.find<LocalUserStorage>();
                        final String? token = await localStorage.getToken();
                        if (token != null) {
                          Get.toNamed(AppRroute.feed);
                        } else {
                          Get.dialog(SubmitDialog(
                            title: "تنبيه",
                            question:
                                "هذه الميزة متاحة فقط للمستخدمين المسجلين.",
                            agreeBottontitle: "تسجيل الدخول",
                            onTapSubmit: () {
                              Get.offAllNamed(AppRroute.auth);
                            },
                          ));
                        }
                      },
                      child:  Text('عرض الكل',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 320, // ⬅️ زدنا الارتفاع قليلاً ليتسع للصورة
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    // الصورة الأولى إن وجدت
                    final String? firstImageUrl =
                        post.images != null && post.images!.isNotEmpty
                            ? post.images!.first.url
                            : null;
                    return Container(
                      width: 240,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.95),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(80, 10),
                          bottomLeft: Radius.elliptical(10, 80),
                          topRight: Radius.elliptical(10, 80),
                          bottomRight: Radius.elliptical(80, 10),
                        ),
                        border: Border.all(color: AppColors.primary, width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. رأس البوست (اسم المستخدم)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: post.publisher?.profilePhoto !=
                                            null &&
                                        post.publisher!.profilePhoto!.isNotEmpty
                                    ? NetworkImage(
                                        post.publisher!.profilePhoto!)
                                    : null,
                                child: post.publisher?.profilePhoto == null ||
                                        post.publisher!.profilePhoto!.isEmpty
                                    ? const Icon(Icons.person, size: 14)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  post.publisher?.fullName ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // 2. ✅ صورة البوست (الجديد)
                          if (firstImageUrl != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                firstImageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 120,
                                  color: AppColors.grey300,
                                  child: const Icon(Icons.broken_image,
                                      color: AppColors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          // 3. محتوى النص (مقتطف)
                          Text(
                            post.content ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 6),

                          // 4. أزرار التفاعل
                          Row(
                            children: [
                              Icon(Icons.thumb_up_outlined,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 2),
                              Text('${post.countLikes ?? 0}',
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 12),
                              Icon(Icons.comment_outlined,
                                  size: 14, color: AppColors.grey),
                              const SizedBox(width: 2),
                              Text('${post.countComments ?? 0}',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
