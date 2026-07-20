// lib/services/remote/local_ai_remote.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../local_storge/local_user_storage.dart';

class LocalAiRemote {
  // Ollama يعمل على المنفذ 11434
  final String baseUrl = "http://localhost:11434";
  final String model = "llama3.2"; // النموذج المستخدم

  Future<String> sendMessage(String message) async {
    final storage = Get.find<LocalUserStorage>();
    final token = await storage.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/generate'),
        headers: {
          'Content-Type': 'application/json',
          // لا يحتاج Ollama إلى توكن، لكننا نحتفظ به للمطابقة مع هيكل التطبيق
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'model': model,
          'prompt': message,
          'stream': false, // نحتاج إلى استجابة كاملة دفعة واحدة
          'options': {
            'temperature': 0.7, // يمكن التحكم به من الإعدادات لاحقاً
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // استجابة Ollama تأتي في حقل "response"
        return data['response'] ?? 'لم أستطع فهم طلبك.';
      } else {
        // محاولة قراءة رسالة الخطأ من الاستجابة
        String errorMsg = 'فشل الاتصال بخادم Ollama';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData.containsKey('error')) {
            errorMsg = errorData['error'];
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }
}