import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/views/public_views/posts/post_card.dart';
import 'package:gr_flutter/views/public_views/posts/create_post_screen.dart';

import '../../../app_route.dart';

class FeedScreen extends StatelessWidget {
  final PostController controller = Get.put(PostController());

  FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('الرئيسية'),
      //   centerTitle: true,
      //   backgroundColor: Colors.blueAccent,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add_circle_outline),
      //       onPressed: () => Get.to(() => CreatePostScreen()),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Get.to(() => CreatePostScreen());
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "images/images_asnan/afeb34f1-66ab-49ac-a13a-e92af739f8e3.jpeg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma()),
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(100, 10),
                bottomLeft: Radius.elliptical(10, 100),
                topRight: Radius.elliptical(10, 100),
                bottomRight: Radius.elliptical(100, 10),
              ),
              border: Border(
                  right: BorderSide(
                    color: Colors.green,
                  ),
                  bottom: BorderSide(
                    color: Colors.green,
                  )),
            ),
            child: Center(
              child: Text(
                "إنشاء منشور  ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchPosts,
              child: Obx(() {
                if (controller.isLoading.value && controller.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.posts.isEmpty) {
                  return const Center(child: Text('لا توجد بوستات بعد، كن أول من ينشر!'));
                }
                return ListView.builder(
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    print("========${post.dislikesCount}");
                    return PostCard(
                      post: post,
                      onLike: () => controller.likePost(post.id),
                      onDislike: () => controller.dislikePost(post.id),
                      onComment: () =>Get.toNamed(AppRroute.postDetail, arguments: post.id),
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