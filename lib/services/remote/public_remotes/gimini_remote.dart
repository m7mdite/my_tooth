
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRemote {
  // final String apiKey = 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M';
  final String apiKey = 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M';
  // final String model = 'gemini-2.5-flash';
  
  Future<String> sendMessage(String userMessage) async {
    try {
      // استخدم النموذج الصحيح
      final model = GenerativeModel(
        model: 'gemini-3-flash-preview', // ✅ هذا النموذج يعمل 100%
        apiKey: apiKey,
      );
      
      final response = await model.generateContent([Content.text(userMessage)]);
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'عذراً، لم أتمكن من الرد على رسالتك.';
      }
      
    } catch (e) {
      return 'حدث خطأ: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}';
    }
  }
}