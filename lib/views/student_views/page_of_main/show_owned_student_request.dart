import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controllers/student_requests_controller.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/requests/show_request_processing.dart';

class ShowOwnedStudentRequest extends StatelessWidget {
  const ShowOwnedStudentRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentRequestsControllerImp>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "طلباتي",
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getProcessingRequest();
          await controller.getCompletedRequests();
        },
        child: Column(
          children: [
            // ===== تبويبات التنقل =====
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // color: AppColors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Obx(
                () => Row(
                  children: [
                    _buildTabButton(
                      label: "قيد المعالجة",
                      index: 0,
                      currentIndex: controller.currentPageIndex.value,
                      onTap: () {
                        controller.changePage(0);
                      },
                    ),
                    _buildTabButton(
                      label: "مكتملة",
                      index: 1,
                      currentIndex: controller.currentPageIndex.value,
                      onTap: () {
                        controller.changePage(1);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // ===== PageView =====
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.changePage(index);
                },
                children: [
                  // الصفحة 0: قيد المعالجة
                  GetBuilder<StudentRequestsControllerImp>(
                    
                    builder: (_) {
                      if (controller.statusRequest == StatusRequest.loading &&
                          controller.processingRequests.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return controller.processingRequests.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: controller.processingRequests.length,
                              itemBuilder: (context, index) {
                                return CardRequestProcessing(
                                  requestModel: controller.processingRequests[index],
                                  onTap: () {
                                    controller.showOnedRequest(
                                      controller.processingRequests[index],
                                    );
                                  },
                                );
                              },
                            )
                          : const DefaultNoData();
                    },
                  ),
                  // الصفحة 1: مكتملة
                  GetBuilder<StudentRequestsControllerImp>(
                    builder: (_) {
                      if (controller.statusRequest == StatusRequest.loading &&
                          controller.completedRequests.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return controller.completedRequests.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: controller.completedRequests.length,
                              itemBuilder: (context, index) {
                                return CardRequestProcessing(
                                  requestModel: controller.completedRequests[index],
                                  onTap: () {
                                    Get.dialog(
                                      ShowRequestProcessing(
                                        requestModel: controller.completedRequests[index],
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : const DefaultNoData();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== بناء زر التبويب =====
  Widget _buildTabButton({
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(
              color: isActive ? AppColors.primary : AppColors.white,
              width: 2,
            )),
            // color: isActive ? AppAppColors.primary700 : AppColors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary200,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.grey.shade600,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}