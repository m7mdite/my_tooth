import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
import 'package:gr_flutter/views/widgets/auth_text_form_field.dart';

import '../../controllers/auth_controllers/auth_controller.dart';
import '../../utils/app_constants/colors_constant.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.92),
          borderRadius:AppThemeConstants.borderRadius,
          border: Border.all(color: AppColors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الأسماء
                Row(
                  children: [
                    Expanded(
                      child: AuthTextFormField(
                        label: "الاسم",
                        textEditingController: controller.registerFirstNameController,
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AuthTextFormField(
                        label: "اسم الأب",
                        textEditingController: controller.registerFatherNameController,
                        icon: Icons.person_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AuthTextFormField(
                  label: "الكنية",
                  textEditingController: controller.registerLastNameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 8),
                AuthTextFormField(
                  label: "البريد الإلكتروني",
                  textEditingController: controller.registerEmailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 8),
                AuthTextFormField(
                  label: "كلمة المرور",
                  textEditingController: controller.registerPasswordController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 8),
                AuthTextFormField(
                  label: "تأكيد كلمة المرور",
                  textEditingController: controller.registerConfirmPasswordController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 12),
                // الجنس (باستخدام SegmentedButton أنيق)
                Row(
                  children: [
                    const Text(
                      "الجنس",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Obx(
                      () => SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'male', label: Text('ذكر')),
                          ButtonSegment(value: 'female', label: Text('أنثى')),
                        ],
                        selected: {controller.gender.value},
                        onSelectionChanged: (set) {
                          controller.gender.value = set.first;
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary100;
                              }
                              return AppColors.grey.shade200;
                            },
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary700;
                              }
                              return AppColors.black87;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // الدور (طالب/مريض)
                Row(
                  children: [
                    const Text(
                      "الدور",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Obx(
                      () => SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'student', label: Text('طالب')),
                          ButtonSegment(value: 'patient', label: Text('مريض')),
                        ],
                        selected: {controller.role.value},
                        onSelectionChanged: (set) {
                          controller.role.value = set.first;
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary100;
                              }
                              return AppColors.grey.shade200;
                            },
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary700;
                              }
                              return AppColors.black87;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // الرقم الجامعي (للطلاب فقط)
                Obx(() {
                  if (controller.role.value == 'student') {
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        AuthTextFormField(
                          label: "الرقم الجامعي",
                          textEditingController: controller.registerUniversityController,
                          icon: Icons.numbers_outlined,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 16),
                AnimatedContainer(
                  padding: EdgeInsets.all(10),
                  duration: const Duration(milliseconds: 300),
                  // width: double.infinity,
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary700, AppColors.primary500],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: AppThemeConstants.borderRadius,
                    border: Border.all(color: AppColors.primary,strokeAlign: 10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.shade300,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.register(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(100, 10),
                      bottomLeft: Radius.elliptical(10, 100),
                      topRight: Radius.elliptical(10, 100),
                      bottomRight: Radius.elliptical(100, 10),
                    ),
                    child: const Center(
                      child: Text(
                        "إنشاء حساب",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}