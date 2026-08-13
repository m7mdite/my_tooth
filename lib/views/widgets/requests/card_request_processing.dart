import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/requests_models/treatment_request_model.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/tooth_constants.dart';

class CardRequestProcessing extends StatelessWidget {
  final TreatmentRequestModel requestModel;
  final Map? toothLocation = ToothConstants.toothLocationMap;
  final UnifiedSettingController settingController =
      Get.find<UnifiedSettingController>();
  final void Function()? onTap;

  CardRequestProcessing({
    super.key,
    required this.requestModel,
    this.onTap,
  });

  // ✅ لون الـ divider والخلفية الداخلية حسب الثيم
  Color get _innerBg => AppColors.cardColor;
  Color get _dividerColor => AppColors.borderColor;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>( // ✅
      builder: (_) {
        final String role = settingController.role.value;

        // لون الـ gender border/shadow — ثابت دلالياً (مو ثيم)
        final Color genderColor = requestModel.requestion!.gender == 'male'
            ? AppColors.primary
            : requestModel.requestion!.gender == 'female'
                ? AppColors.pink
                : AppColors.borderColor;

        return InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.authBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
              ),
              color: AppColors.cardColor, // ✅ بدل white
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(100, 10),
                bottomLeft: Radius.elliptical(10, 100),
                topRight: Radius.elliptical(10, 100),
                bottomRight: Radius.elliptical(100, 10),
              ),
              boxShadow: [
                BoxShadow(
                  color: genderColor,
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                strokeAlign: 10,
                color: genderColor,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                // ===== موقع السن =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toothLocation?[requestModel.requestion!.toothLocation] ??
                          "غير محدد",
                      style: TextStyle(
                        color: AppColors.textPrimary, // ✅
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.3),
                            blurRadius: 1,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    FaIcon(FontAwesomeIcons.tooth, color: AppColors.white),
                  ],
                ),

                Divider(color: _dividerColor, height: 8), // ✅ بدل Container أبيض

                // ===== المادة والحالة =====
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (requestModel.courseInfo != null) ...[
                      Text("المادة",
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textPrimary)),
                      Flexible(child: _infoChip(requestModel.courseInfo!.courseName ?? "")),
                    ],
                    Container(
                      width: 2,
                      height: 20,
                      color: _dividerColor, // ✅
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text("الحالة",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textPrimary)),
                    Flexible(
                        child: _infoChip(requestModel.caseType!.caseType ?? "")),
                  ],
                ),

                Divider(color: _dividerColor, height: 8), // ✅

                // ===== شدة الألم ووقته =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("شدة الألم: ",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textPrimary)),
                    Flexible(
                      child: _infoChipWidget(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final filled =
                                requestModel.requestion!.painSeverity! >= i + 1;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: filled
                                      ? (i < 2
                                          ? AppColors.errorAccent
                                          : AppColors.error)
                                      : _innerBg, // ✅
                                  border: Border.all(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Text("وقت الألم: ",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textPrimary)),
                    Flexible(
                      child: _infoChip(
                          requestModel.requestion!.painTime ?? "غير محدد"),
                    ),
                  ],
                ),

                Divider(color: _dividerColor, height: 8), // ✅

                // ===== تنبيه المشرف =====
                if (requestModel.overseer == null &&
                    requestModel.status == "processing" &&
                    role == "student") ...[
                  Divider(color: _dividerColor, height: 8),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "يتعين عليك تعيين مشرف!",
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ chip نصي موحد
  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.cardColor, // ✅
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
      ),
      child: Text(text, style: TextStyle(color: AppColors.textPrimary)), // ✅
    );
  }

  // ✅ chip يقبل widget داخله
  Widget _infoChipWidget(Widget child) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.cardColor, // ✅
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
      ),
      child: child,
    );
  }
}
