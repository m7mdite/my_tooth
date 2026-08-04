import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_users_controller.dart';

import '../../models/admin_models/veify_student_model.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/auth_text_form_field.dart';
import '../widgets/dialog/submit_dialog.dart';

// يرجى التأكد من أنك أضفت الكلاس VeifyStudentModel وجميع الكلاسات التابعة له هنا.

class SubmitVerifyStudent extends StatelessWidget {
  final AdminUsersControllerImpl controller =
      Get.find<AdminUsersControllerImpl>();
  final VeifyStudentModel? studentModel;

  SubmitVerifyStudent({super.key, this.studentModel});

  @override
  Widget build(BuildContext context) {
    final profile = studentModel!.studentProfile;
    if (profile == null) {
      return const Center(child: Text("لم تتوفر بيانات الطالب"));
    }

    return Material(
      color: AppColors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
            color: AppColors.white
            // image: DecorationImage(image: AssetImage(AppConstants.defaultBackgroundImage), fit: BoxFit.cover),
            ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة الطالب
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.grey200,
              backgroundImage: profile.profilePhoto!.url != null
                  ? NetworkImage(
                      profile.profilePhoto!.url!)
                  : null,
              child: profile.profilePhoto?.url == null
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),
            const SizedBox(height: 16),
            // اسم الطالب الثلاثي
            Text(
              "${profile.firstName ?? ''} ${profile.fatherName ?? ''} ${profile.lastName ?? ''}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // الرقم الجامعي
            Text(
              "الرقم الجامعي: ${profile.universityNumber ?? '--'}",
              style: const TextStyle(fontSize: 16, color: AppColors.black),
            ),
            const SizedBox(height: 16),
            // صورة البطاقة الجامعية

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "صورة البطاقة الجامعية:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${studentModel!.document!}",
                    fit: BoxFit.cover,
                    height: 160,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.acceptVerifyStudent(studentModel!.sId!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("توثيق"),
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.success,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: const Text("تعديل"),
                // ),
                ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      SubmitDialog(
                        title: "رفض التوثيق",
                        question: "هل أنت متأكد أنك تريد رفض توثيق هذا الطالب؟",
                        children: [
                          Flexible(
                            child: AuthTextFormField(
                              label: "سبب الرفض",
                              textEditingController:
                                  controller.rejectReasonController,
                            ),
                          ),
                        ],
                        onTapSubmit: () {
                          controller.rejectVerifyStudent(studentModel!.sId!);
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("رفض"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
