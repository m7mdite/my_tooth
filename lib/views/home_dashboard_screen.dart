import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_photo_app_bar.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../controllers/home_dashboard_controller.dart';
import '../models/dashboard_model.dart';

class HomeDashboardScreen extends StatelessWidget {
  HomeDashboardScreen({super.key});

  final HomeDashboardController controller = Get.put(HomeDashboardController());
  final UnifiedSettingController settingController = Get.find<UnifiedSettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الرئيسية",
        actions: [
          CustomIconAppBar(
            iconData: Icons.chat,
            onTap: () => Get.toNamed(AppRroute.conversations),
          ),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () => Get.toNamed(AppRroute.notificationsView),
            reverseColors: true,
          ),
        ],
        automaticallyImplyLeading: false,
        leading: Obx(() {
          final pic = settingController.profilePicture.value;
          return InkWell(
            onTap: () => Get.toNamed(AppRroute.unifiedProfileScreen),
            child: CustomPhotoAppBar(pic: pic),
          );
        }),
      ),
      body: RefreshIndicator(
        onRefresh: ()async {
         controller.onInit(); 
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.dashboard.value == null) {
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
                    _buildStatsSection(dashboard.requests!),
        
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

  Widget _buildStatsSection(Requests stats) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(100, 10),
                bottomLeft: Radius.elliptical(10, 100),
                topRight: Radius.elliptical(10, 100),
                bottomRight: Radius.elliptical(100, 10),
              ),
              boxShadow: [BoxShadow(color: Colors.blue.shade200, blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إحصائيات الطلبات', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('قيد الانتظار', stats.pending ?? 0, Colors.orange),
                    _statItem('قيد المعالجة', stats.processing ?? 0, Colors.blue),
                    _statItem('مكتملة', stats.finished ?? 0, Colors.green),
                  ],
                ),
                const Divider(color: Colors.white54, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('إجمالي الطلبات: ', style: TextStyle(color: Colors.white70)),
                    Text('${stats.total ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 13)),
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
                        color: adv.image?.url == null ? Colors.blue.shade400 : null,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(80, 10),
                          bottomLeft: Radius.elliptical(10, 80),
                          topRight: Radius.elliptical(10, 80),
                          bottomRight: Radius.elliptical(80, 10),
                        ),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 3))],
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
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Text(
                                adv.content ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
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
                        color: controller.currentAdvIndex.value == i ? Colors.blue : Colors.grey.shade300,
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
            child: Row(
              children: [
                // Expanded(
                //   child: _actionButton(
                //     icon: Icons.history,
                //     label: 'الطلبات',
                //     color: Colors.blue,
                //     onTap: () => Get.toNamed(AppRroute.homeScreenAll),
                //   ),
                // ),
                // const SizedBox(width: 16),
                Expanded(
                child: _actionButton(
                  icon: Icons.chat, // ✅ أو استخدم FontAwesomeIcons.robot
                  label: ' المساعد الذكي',
                  color: Colors.green, // لون مميز
                  onTap: () => Get.toNamed(AppRroute.aiChat),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          border: Border.all(color: color, width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
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
                  const Text(
                    'أفضل المنشورات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRroute.feed),
                    child: const Text('عرض الكل', style: TextStyle(color: Colors.blue)),
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
                  final String? firstImageUrl = post.images != null && post.images!.isNotEmpty
                      ? post.images!.first.url
                      : null;
                  return Container(
                    width: 240,
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(80, 10),
                        bottomLeft: Radius.elliptical(10, 80),
                        topRight: Radius.elliptical(10, 80),
                        bottomRight: Radius.elliptical(80, 10),
                      ),
                      border: Border.all(color: Colors.blue, width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. رأس البوست (اسم المستخدم)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: post.publisher?.profilePhoto != null &&
                                      post.publisher!.profilePhoto!.isNotEmpty
                                  ? NetworkImage(post.publisher!.profilePhoto!)
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                            child:
                            
                            
                            
                             Image.network(
                              firstImageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 120,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
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
                            Icon(Icons.thumb_up_outlined, size: 14, color: Colors.blue),
                            const SizedBox(width: 2),
                            Text('${post.countLikes ?? 0}', style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 12),
                            Icon(Icons.comment_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 2),
                            Text('${post.countComments ?? 0}', style: const TextStyle(fontSize: 12)),
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
}}