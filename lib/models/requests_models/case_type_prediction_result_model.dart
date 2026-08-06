// models/requests_models/case_type_prediction_result_model.dart

/// موديل نتيجة التنبؤ بنوع المعالجة من endpoint:
/// POST /api/treatment-ml/predict-with-image
/// {
///   "case_type_id": "...",
///   "case_type_name": "غير معروف",
///   "probability": "50.00%",
///   "image_used": false,
///   "all_probabilities": ["50.00%"]
/// }
class CaseTypePredictionResult {
  final String caseTypeId;
  final String caseTypeName;
  final String probability;
  final bool imageUsed;
  final List<String> allProbabilities;

  const CaseTypePredictionResult({
    required this.caseTypeId,
    required this.caseTypeName,
    required this.probability,
    required this.imageUsed,
    required this.allProbabilities,
  });

  factory CaseTypePredictionResult.fromJson(Map<String, dynamic> json) {
    return CaseTypePredictionResult(
      caseTypeId: json['case_type_id']?.toString() ?? '',
      caseTypeName: json['case_type_name']?.toString() ?? 'غير معروف',
      probability: json['probability']?.toString() ?? '',
      imageUsed: json['image_used'] == true,
      allProbabilities: (json['all_probabilities'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
