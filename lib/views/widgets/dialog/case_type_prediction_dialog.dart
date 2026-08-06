import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../models/requests_models/case_type_prediction_result_model.dart';
import '../../../utils/app_constants/colors_constant.dart';

/// ديالوغ عرض نتيجة التنبؤ بنوع المعالجة المتوقع.
/// ملاحظة: هاي نتيجة تقديرية بالذكاء الاصطناعي فقط، مش تشخيص نهائي —
/// المريض ما زال حر يختار نوع المعالجة يدوياً بالفورم زي ما هو.
class CaseTypePredictionDialog extends StatelessWidget {
  final CaseTypePredictionResult result;

  const CaseTypePredictionDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          width: Get.width * 0.75,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 255, 255),
            border: Border.all(width: 3.5, color: AppColors.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
                opacity: 0.85,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                FaIcon(
                  FontAwesomeIcons.tooth,
                  color: AppColors.primary,
                  size: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  "النوع المتوقع: ${result.caseTypeName}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  height: 2,
                  color: AppColors.white,
                  width: 180,
                ),
                if (result.probability.isNotEmpty)
                  Text(
                    'نسبة الثقة بالتقدير: ${result.probability}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (result.imageUsed) ...[
                  const SizedBox(height: 6),
                  Text(
                    '📷 تم استخدام الصورة المرفقة بالتنبؤ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary700,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'هذا تقدير مبدئي بمساعدة الذكاء الاصطناعي بناءً على البيانات '
                    'المدخلة، وليس تشخيصاً طبياً نهائياً. ما زال بإمكانك اختيار '
                    'نوع المعالجة يدوياً، والقرار الفعلي يعود للمشرف المختص.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 26),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(width: 1.5, color: AppColors.primary),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Text('إغلاق',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
