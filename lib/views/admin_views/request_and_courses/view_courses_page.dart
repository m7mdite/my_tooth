import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewCoursesPage extends StatelessWidget {
  final AdminRequestControllerImpl controller =
      Get.find<AdminRequestControllerImpl>();

  ViewCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "عرض المواد الدراسية",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllCourses(),
        child: GetBuilder<AdminRequestControllerImpl>(
          builder: (controller) {
            if (controller.statusRequest == StatusRequest.loading &&
                controller.courses.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.courses.isEmpty) {
              return const Center(child: Text("لا توجد مواد بعد"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.courses.length,
              separatorBuilder: (context, index) {
                return  Divider(
                  color: AppColors.primary,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                final course = controller.courses[index];
                // return Card(
                //   margin: const EdgeInsets.only(bottom: 12),
                //   elevation: 2,
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                //   child: ExpansionTile(
                //     leading: CircleAvatar(
                //       backgroundColor: AppColors.primary,
                //       child: Text("${index + 1}", style: const TextStyle(color: AppColors.white)),
                //     ),
                //     title: Text(
                //       course.courseName ?? "اسم غير متوفر",
                //       style: const TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     subtitle: Text("عدد المشرفين: ${course.overseers?.length ?? 0}"),
                //     children: [
                //       if (course.overseers != null && course.overseers!.isNotEmpty)
                //         Padding(
                //           padding: const EdgeInsets.all(12),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               const Text(
                //                 "المشرفون:",
                //                 style: TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //               const SizedBox(height: 8),
                //               ...course.overseers!.map((overseer) => ListTile(
                //                     leading: const Icon(Icons.person, size: 20),
                //                     title: Text("${overseer.firstName} ${overseer.lastName}"),
                //                     subtitle: Text(overseer.email ?? ""),
                //                     dense: true,
                //                   )),
                //             ],
                //           ),
                //         )
                //       else
                //         const Padding(
                //           padding: EdgeInsets.all(12),
                //           child: Text("لا يوجد مشرفون مرتبطون بهذه المادة"),
                //         ),
                //       const SizedBox(height: 8),
                //     ],
                //   ),
                // );
                return ListTile(
                  // leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(course.courseName ?? "غير متوفر"),
                  // subtitle: Text("عدد المشرفين: ${course.}"),
                  // subtitle:
                  //     Text("المشرفين: ${course.overseers!.category1!.length ?? 0}"),
                  // trailing: const Icon(Icons.chevron_right),
                  // onTap: () {
                  //   // يمكن فتح صفحة تفاصيل المادة
                  // },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
