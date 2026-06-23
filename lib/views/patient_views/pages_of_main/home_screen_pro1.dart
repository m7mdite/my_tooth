import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/home_patient_controller.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/models/posts_models/post_model.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/app_route.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../public_views/conversations_screen.dart';
import '../../public_views/notifications_view.dart';
import '../../public_views/settings/unified_profile_screen.dart';
import '../../widgets/container_images_home_inbording.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../../widgets/custom_photo_app_bar.dart';

class HomeScreenPro1 extends StatefulWidget {
  const HomeScreenPro1({super.key});

  @override
  State<HomeScreenPro1> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<HomeScreenPro1> {
  final HomePatientControllerImp controller = Get.put(HomePatientControllerImp());
  final UnifiedSettingController settingController = Get.find<UnifiedSettingController>();
  final PostController postController = Get.find<PostController>();

  // لمشاهدة البوستات الأفقية
  late PageController _postsPageController;
  int _currentPostIndex = 0;
  Timer? _postsAutoScrollTimer;

  @override
  void initState() {
    super.initState();
    _postsPageController = PageController(viewportFraction: 0.85);
    _startPostsAutoScroll();
  }

  void _startPostsAutoScroll() {
    _postsAutoScrollTimer?.cancel();
    _postsAutoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (postController.posts.isEmpty) return;
      if (_postsPageController.hasClients) {
        final nextPage = (_currentPostIndex + 1) % postController.posts.length;
        _postsPageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPostIndex = nextPage);
      }
    });
  }

  @override
  void dispose() {
    _postsAutoScrollTimer?.cancel();
    _postsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PostModel> recentPosts = postController.posts.take(10).toList(); // خذ أول 10 بوستات مثلاً

    return Scaffold(
      appBar: CustomAppBar(
        title: "الصفحة الرئيسية",
        actions: [
          CustomIconAppBar(
            iconData: Icons.chat,
            onTap: () => Get.to(() => ConversationsScreen()),
          ),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () => Get.to(() => NotificationsView()),
            reverseColors: true,
          ),
        ],
        automaticallyImplyLeading: false,
        leading: Obx(() {
          final pic = settingController.profilePicture.value;
          return InkWell(
            onTap: () => Get.to(() => UnifiedProfileScreen()),
            child: CustomPhotoAppBar(pic: pic),
          );
        }),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // ===== 1. Carousel للصور =====
                AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: SizedBox(
                        height: Get.width * 0.6,
                        width: Get.width * 0.8,
                        child: PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: (value) {
                            controller.currentPage = value;
                            controller.update();
                          },
                          itemCount: controller.listImages.length,
                          itemBuilder: (context, index) {
                            return ContainerImagesHomeInbording(
                              image: controller.listImages[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // ===== 2. زر "إسأل حكيم" =====
                AnimationConfiguration.staggeredList(
                  position: 1,
                  duration: Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Center(
                        child: InkWell(
                          onTap: () => controller.toAiChatPage(),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue, width: 1, strokeAlign: 15),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(100, 10),
                                bottomLeft: Radius.elliptical(10, 100),
                                topRight: Radius.elliptical(10, 100),
                                bottomRight: Radius.elliptical(100, 10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(FontAwesomeIcons.userDoctor, color: Colors.blue),
                                SizedBox(width: 30),
                                Text("إسأل حكيم ...", style: TextStyle(color: Colors.blue, fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // ===== 3. بوستات أفقية متقلبة =====
                if (recentPosts.isNotEmpty) ...[
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "أحدث المنشورات",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed(AppRroute.feed),
                                child: Text(
                                  "عرض المزيد",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 3,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: PageView.builder(
                            
                            controller: _postsPageController,
                            onPageChanged: (index) {
                              setState(() => _currentPostIndex = index);
                            },
                            itemCount: recentPosts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: _buildPostCard(recentPosts[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // نقاط التقدم (اختياري)
                  AnimationConfiguration.staggeredList(
                    position: 4,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(recentPosts.length, (i) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPostIndex == i ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPostIndex == i ? Colors.blue : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // إذا لم توجد بوستات
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(100, 10),
                              bottomLeft: Radius.elliptical(10, 100),
                              topRight: Radius.elliptical(10, 100),
                              bottomRight: Radius.elliptical(100, 10),
                            ),
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "لا توجد منشورات حالياً",
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== بناء بطاقة البوست ==========
  Widget _buildPostCard(PostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
        border: Border.all(color: Colors.blue, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البوست
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: post.publisher!.profilePhoto != null
                      ? NetworkImage('${post.publisher!.profilePhoto}')
                      : null,
                  child: post.publisher!.profilePhoto == null ? Icon(Icons.person, size: 18) : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.publisher!.fullName!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getRoleName(post.publisherRole!),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTime(DateTime.now()),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            SizedBox(height: 12),
            // المحتوى (مقتطف)
            Text(
              post.content!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            // الصورة (أول صورة)
            if (post.images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${post.images!.first.url}',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => SizedBox(height: 120, child: Center(child: Icon(Icons.broken_image))),
                ),
              ),
            SizedBox(height: 12),
            // التفاعلات
            Row(
              children: [
                Icon(Icons.thumb_up_outlined, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text('${post.countLikes}'),
                SizedBox(width: 16),
                Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('${post.countComments}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== دوال مساعدة ==========
  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
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








// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/patient_controller/home_patient_controller.dart';
// import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
// import 'package:gr_flutter/models/posts_models/post_model.dart';
// import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
// import 'package:gr_flutter/app_route.dart';

// import '../../../controllers/public_controllers/unified_setting_controller.dart';
// import '../../public_views/conversations_screen.dart';
// import '../../public_views/notifications_view.dart';
// import '../../public_views/settings/unified_profile_screen.dart';
// import '../../widgets/container_images_home_inbording.dart';
// import '../../widgets/custom_icon_app_bar.dart';
// import '../../widgets/custom_photo_app_bar.dart';

// class HomeScreenPro1 extends StatelessWidget {
//   final HomePatientControllerImp controller = Get.put(HomePatientControllerImp());
//   final UnifiedSettingController settingController = Get.find<UnifiedSettingController>();
//   final PostController postController = Get.find<PostController>();

//   HomeScreenPro1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // جلب أول 3 بوستات من القائمة (إذا كانت موجودة)
//     final List<PostModel> recentPosts = postController.posts.take(3).toList();

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "الصفحة الرئيسية",
//         actions: [
//           CustomIconAppBar(
//             iconData: Icons.chat,
//             onTap: () => Get.to(() => ConversationsScreen()),
//           ),
//           CustomIconAppBar(
//             iconData: Icons.notifications,
//             onTap: () => Get.to(() => NotificationsView()),
//             reverseColors: true,
//           ),
//         ],
//         automaticallyImplyLeading: false,
//         leading: Obx(() {
//           final pic = settingController.profilePicture.value;
//           return InkWell(
//             onTap: () => Get.to(() => UnifiedProfileScreen()),
//             child: CustomPhotoAppBar(pic: pic),
//           );
//         }),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.linearToSrgbGamma(),
//           ),
//         ),
//         child: AnimationLimiter(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             padding: EdgeInsets.only(bottom: 20),
//             child: Column(
//               children: [
//                 // ===== 1. Carousel =====
//                 AnimationConfiguration.staggeredList(
//                   position: 0,
//                   duration: Duration(milliseconds: 600),
//                   child: SlideAnimation(
//                     verticalOffset: 50,
//                     child: FadeInAnimation(
//                       child: SizedBox(
//                         height: Get.width * 0.6,
//                         width: Get.width * 0.4,
//                         child: PageView.builder(
//                           controller: controller.pageController,
//                           onPageChanged: (value) {
//                             controller.currentPage = value;
//                             controller.update();
//                           },
//                           itemCount: controller.listImages.length,
//                           itemBuilder: (context, index) {
//                             return ContainerImagesHomeInbording(
//                               image: controller.listImages[index],
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // ===== 2. زر "إسأل حكيم" =====
//                 AnimationConfiguration.staggeredList(
//                   position: 1,
//                   duration: Duration(milliseconds: 600),
//                   child: SlideAnimation(
//                     verticalOffset: 50,
//                     child: FadeInAnimation(
//                       child: Center(
//                         child: InkWell(
//                           onTap: () => controller.toAiChatPage(),
//                           child: Container(
//                             padding: EdgeInsets.all(15),
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.blue, width: 1, strokeAlign: 15),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.elliptical(100, 10),
//                                 bottomLeft: Radius.elliptical(10, 100),
//                                 topRight: Radius.elliptical(10, 100),
//                                 bottomRight: Radius.elliptical(100, 10),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 FaIcon(FontAwesomeIcons.userDoctor, color: Colors.blue),
//                                 SizedBox(width: 30),
//                                 Text("إسأل حكيم ...", style: TextStyle(color: Colors.blue, fontSize: 18)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 // ===== 3. قسم المنشورات =====
//                 if (recentPosts.isNotEmpty) ...[
//                   AnimationConfiguration.staggeredList(
//                     position: 2,
//                     duration: Duration(milliseconds: 600),
//                     child: SlideAnimation(
//                       verticalOffset: 50,
//                       child: FadeInAnimation(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "أحدث المنشورات",
//                                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
//                               ),
//                               TextButton(
//                                 onPressed: () => Get.toNamed(AppRroute.feed),
//                                 child: Text(
//                                   "عرض المزيد",
//                                   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ...recentPosts.map((post) {
//                     final index = recentPosts.indexOf(post);
//                     return AnimationConfiguration.staggeredList(
//                       delay: Duration(seconds: 1),
//                       position: index + 3,
//                       duration: Duration(milliseconds: 600),
//                       child: SlideAnimation(

//                         verticalOffset: 50,
//                         child: FadeInAnimation(
//                           child: _buildPostCard(post),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ] 
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ========== بناء بطاقة البوست ==========
//   Widget _buildPostCard(PostModel post) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.elliptical(100, 10),
//           bottomLeft: Radius.elliptical(10, 100),
//           topRight: Radius.elliptical(10, 100),
//           bottomRight: Radius.elliptical(100, 10),
//         ),
//         border: Border.all(color: Colors.blue, width: 1.2),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // رأس البوست (المستخدم)
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundImage: post.publisher!.profilePhoto != null
//                       ? NetworkImage('${post.publisher!.profilePhoto}')
//                       : null,
//                   child: post.publisher!.profilePhoto == null ? Icon(Icons.person, size: 18) : null,
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         post.publisher!.fullName!,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         _getRoleName(post.publisherRole!),
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   _formatTime(DateTime.now()),
//                   style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             // المحتوى (مقتطف)
//             Text(
//               post.content!,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: 15),
//             ),
//             SizedBox(height: 10),
//             // الصور (عرض أول صورة إن وجدت)
//             if (post.images!.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   '${post.images!.first.url}',
//                   height: 160,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => SizedBox(height: 160, child: Center(child: Icon(Icons.broken_image))),
//                 ),
//               ),
//             SizedBox(height: 12),
//             // عدد التفاعلات
//             Row(
//               children: [
//                 Icon(Icons.thumb_up_outlined, size: 16, color: Colors.blue),
//                 SizedBox(width: 4),
//                 Text('${post.countLikes}'),
//                 SizedBox(width: 16),
//                 Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text('${post.countComments}'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ========== دوال مساعدة ==========
//   String _formatTime(DateTime date) {
//     final diff = DateTime.now().difference(date);
//     if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
//     if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
//     if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
//     return 'الآن';
//   }

//   String _getRoleName(String role) {
//     switch (role) {
//       case 'student': return 'طالب';
//       case 'patient': return 'مريض';
//       case 'overseer': return 'مشرف';
//       case 'admin': return 'مدير';
//       default: return role;
//     }
//   }
// }