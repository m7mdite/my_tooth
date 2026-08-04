// models/requests_models/prediction_result_model.dart

/// موديل نتيجة التنبؤ القادمة من endpoint الـ ML:
/// {"prediction":"✅ مقبولة","prediction_code":1,"confidence":"60.00%"}
class PredictionResult {
  final String prediction;
  final int predictionCode;
  final String confidence;

  const PredictionResult({
    required this.prediction,
    required this.predictionCode,
    required this.confidence,
  });

  /// 1 = الحالة قابلة للعلاج، أي قيمة تانية = غير قابلة (حسب الباك).
  bool get isAccepted => predictionCode == 1;

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final rawCode = json['prediction_code'];
    final code = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '') ?? 0;

    return PredictionResult(
      prediction: json['prediction']?.toString() ?? '',
      predictionCode: code,
      confidence: json['confidence']?.toString() ?? '',
    );
  }
}
