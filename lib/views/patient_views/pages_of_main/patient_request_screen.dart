import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
import 'package:gr_flutter/controllers/requests_controllers/fill_request_controller.dart';
import 'package:gr_flutter/views/patient_views/dialog_request/dialog_send_request.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../public_views/conversations_screen.dart';
import '../../public_views/notifications_view.dart';
import '../../public_views/settings/unified_profile_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../../widgets/custom_photo_app_bar.dart';

// import 'request_details_screen.dart';
// import 'requests_list_screen.dart';

class PatientRequestScreen extends StatelessWidget {
  final PatientRequestControllerImp controller =
      Get.put(PatientRequestControllerImp());
  final FillRequestControllerImp controllerr =
      Get.put(FillRequestControllerImp());
  final UnifiedSettingController settingController =
      Get.find<UnifiedSettingController>();
  PatientRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "طلبات المعالجة",
        automaticallyImplyLeading: false,
        actions: [
          CustomIconAppBar(
              iconData: Icons.chat,
              onTap: () {
                Get.to(() => ConversationsScreen());
              }),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () {
              Get.to(() => NotificationsView());
            },
            reverseColors: true,
          ),
        ],
        leading: Obx(
          () {
            final pic = settingController.profilePicture.value;
            return InkWell(
              onTap: () {
                // هنا يمكنك إضافة وظيفة عند الضغط على الصورة الشخصية
                Get.to(() => UnifiedProfileScreen());
              },
              child: CustomPhotoAppBar(pic: pic),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Get.dialog(
                DialogSendRequest(
                  send: () {
                    controller.sendRequest();
                  },
                  cancel: () {
                    controller.cancelSendRequest();
                  },
                ),
              );
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
                      color: AppColors.success,
                    ),
                    bottom: BorderSide(
                      color: AppColors.success,
                    )),
              ),
              child: Center(
                child: Text(
                  "تقديم طلب",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: AppColors.white,
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
          // BottomContainer(
          //   body: "تقديم طلب",
          //   paddingHorizontal: 20,
          //   onTap: () {
          //     controllerr.showDialog("send");
          //   },
          // ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("طلباتي"),
              InkWell(
                onTap: () {
                  controller.refreshData();
                },
                child: Icon(
                  Icons.refresh_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            width: Get.width * 0.75,
            color: AppColors.primary,
          ),
          SizedBox(
            height: 10,
          ),
          GetBuilder<PatientRequestControllerImp>(builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      controller.toPageView(0);
                    },
                    child: Text(
                      "قيد الإنتظار",
                      style: TextStyle(
                        color: controller.currentPageFilter == 0
                            ? AppColors.primary
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      controller.toPageView(1);
                    },
                    child: Text(
                      "قيد المعالجة ",
                      style: TextStyle(
                        color: controller.currentPageFilter == 1
                            ? AppColors.primary
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      controller.toPageView(2);
                    },
                    child: Text(
                      "الطلبات المعالجة",
                      style: TextStyle(
                        color: controller.currentPageFilter == 2
                            ? AppColors.primary
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      controller.toPageView(3);
                    },
                    child: Text(
                      "الطلبات المرفوضة",
                      style: TextStyle(
                        color: controller.currentPageFilter == 3
                            ? AppColors.primary
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: 4,
              onPageChanged: (value) {
                controller.currentPageFilter = value;
                controller.update();
              },
              itemBuilder: (context, indexPage) {
                return GetBuilder<PatientRequestControllerImp>(
                  builder: (_) {
                    return controller.getListRequest().isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.getListRequest().length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  controller.getListRequest().length ) {
                                return SizedBox(
                                  height: 60,
                                );
                              }
                              return controller.currentPageFilter == 0
                                  ? CardRequestProcessing(
                                      onTap: () {
                                        controller.showRequest(controller
                                            .requestListPending[index]);
                                      },
                                      requestModel:
                                          controller.getListRequest()[index],
                                    )
                                  : controller.currentPageFilter == 1
                                      ? CardRequestProcessing(
                                          requestModel: controller
                                              .requestListProcessing[index],
                                          onTap: () {
                                            controller.showProcessingRequest(
                                                controller
                                                        .requestListProcessing[
                                                    index]);
                                          },
                                        )
                                      : CardRequestProcessing(
                                          requestModel: controller
                                              .requestListCompleted[index],
                                          onTap: () {},
                                        );
                            },
                          )
                        : DefaultNoData();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
