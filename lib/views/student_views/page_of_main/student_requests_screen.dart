import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../controllers/student_controllers/student_requests_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../public_views/conversations_screen.dart';
import '../../public_views/notifications_view.dart';
import '../../public_views/settings/unified_profile_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../../widgets/custom_photo_app_bar.dart';
import '../../widgets/requests/card_request_processing.dart';

class StudentRequestsScreen extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.put(StudentRequestsControllerImp());
  final UnifiedSettingController settingController =
      Get.find<UnifiedSettingController>();

  StudentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>( // ✅
      builder: (_) {
        return GetBuilder<StudentRequestsControllerImp>(
          builder: (_) {
            return Scaffold(
              backgroundColor: AppColors.background, // ✅
              appBar: CustomAppBar(
                title: "طلبات المعالجة",
                automaticallyImplyLeading: false,
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
                leading: Obx(() {
                  final pic = settingController.profilePicture.value;
                  return InkWell(
                    onTap: () => Get.to(() => UnifiedProfileScreen()),
                    child: CustomPhotoAppBar(pic: pic),
                  );
                }),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: InkWell(
                onTap: () => controller.showMyRequest(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9), // ✅ بدل white24
                    border: Border.all(
                        width: 1,
                        color: AppColors.primary,
                        strokeAlign: 10),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(100, 10),
                      bottomLeft: Radius.elliptical(10, 100),
                      topRight: Radius.elliptical(10, 100),
                      bottomRight: Radius.elliptical(100, 10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2), // ✅
                        blurRadius: 3,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.tooth,
                          color: AppColors.primary), // ✅
                      Text(
                        "  طلباتي",
                        style: TextStyle(color: AppColors.textPrimary), // ✅
                      ),
                    ],
                  ),
                ),
              ),
              body: RefreshIndicator(
                color: AppColors.primary, // ✅
                onRefresh: () async {
                  await controller.getPendingRequests();
                },
                child: controller.pendingRequests.isEmpty
                    ? DefaultNoData()
                    : ListView.builder(
                        itemCount: controller.pendingRequests.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.pendingRequests.length) {
                            return const SizedBox(height: 100);
                          }
                          return CardRequestProcessing(
                            requestModel: controller.pendingRequests[index],
                            onTap: () {
                              controller.showRequest(
                                  controller.pendingRequests[index]);
                            },
                          );
                        },
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
