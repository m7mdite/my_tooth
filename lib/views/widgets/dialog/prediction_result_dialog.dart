import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/requests_models/prediction_result_model.dart';

/// ديالوغ عرض نتيجة التنبؤ بإمكانية علاج الحالة.
/// ملاحظة: هاي نتيجة تقديرية بالذكاء الاصطناعي فقط، مش تشخيص نهائي —
/// القرار الفعلي يرجع دائماً للمشرف المختص بعد مراجعة الطلب.
class PredictionResultDialog extends StatelessWidget {
  final PredictionResult result;

  const PredictionResultDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final Color color = result.isAccepted ? Colors.green : Colors.red;

    return Center(
      child: Material(
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          width: Get.width * 0.75,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 255, 255),
            border: Border.all(width: 3.5, color: Colors.white),
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
                Icon(
                  result.isAccepted ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 54,
                ),
                const SizedBox(height: 8),
                Text(
                  result.prediction,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  height: 2,
                  color: Colors.white,
                  width: 180,
                ),
                if (result.confidence.isNotEmpty)
                  Text(
                    'نسبة الثقة بالتقدير: ${result.confidence}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'هذا تقدير مبدئي بمساعدة خوارزميات التعلم  بناءً على البيانات '
                    'المدخلة، وليس تشخيصاً طبياً نهائياً. القرار الفعلي يعود '
                    'للمشرف المختص بعد مراجعة طلبك.',
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
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: color),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(100, 10),
                        bottomLeft: Radius.elliptical(10, 100),
                        topRight: Radius.elliptical(10, 100),
                        bottomRight: Radius.elliptical(100, 10),
                      ),
                    ),
                    child: Text('إغلاق', style: TextStyle(color: color)),
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
