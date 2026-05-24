// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   // 1. تهيئة النموذج
//   final GenerativeModel _model = GenerativeModel(
//     model: 'gemini-2.5-flash', // اختر النموذج المناسب
//     apiKey: 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M', // استخدم متغير بيئة لحماية المفتاح
//   );

//   // 2. دالة لإرسال رسالة واستقبال رد
//   Future<String> sendMessage(String userMessage) async {
//     try {
//       final content = [Content.text(userMessage)];
//       final response = await _model.generateContent(content);
//       return response.text ?? 'لم يتم استلام رد.';
//     } catch (e) {
//       print('Error: $e');
//       return 'حدث خطأ، يرجى المحاولة مرة أخرى.';
//     }
//   }
// }




// // services/gemini_service.dart
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   // تأكد من استخدام مفتاح API صحيح
//   final String apiKey = 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M'; // هذا المفتاح غير كامل!
  
//   Future<String> sendMessage(
//     String userMessage, {
//     String model = 'gemini-2.5-flash',
//     double temperature = 0.7,
//   }) async {
//     try {
//       print('📤 جاري إرسال الرسالة: $userMessage');
      
//       // تأكد من أن المفتاح ليس فارغاً
//       // if (apiKey.isEmpty || apiKey == 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M') {
//       //   throw Exception('مفتاح API غير صالح. يرجى إدخال مفتاح صحيح من Google AI Studio');
//       // }
      
//       final GenerativeModel model0 = GenerativeModel(
//         model: model,
//         apiKey: apiKey,
//         generationConfig: GenerationConfig(
//           temperature: temperature,
//           maxOutputTokens: 1000,
//           topP: 0.95,
//           topK: 40,
//         ),
//       );
      
//       final content = [Content.text(userMessage)];
//       final response = await model0.generateContent(content);
      
//       print('📥 تم استلام الرد: ${response.text}');
      
//       if (response.text == null || response.text!.isEmpty) {
//         return 'عذراً، لم أتمكن من إنشاء رد. يرجى المحاولة مرة أخرى.';
//       }
      
//       return response.text!;
      
//     } on GenerativeAIException catch (e) {
//       print('❌ خطأ في Gemini API: ${e.message}');
      
//       // معالجة أخطاء محددة من Gemini
//       if (e.message.contains('API key')) {
//         return 'خطأ: مفتاح API غير صالح. يرجى التحقق من المفتاح في ملف الإعدادات.';
//       } else if (e.message.contains('quota')) {
//         return 'تم تجاوز الحصة المجانية. يرجى المحاولة لاحقاً أو ترقية حسابك.';
//       } else if (e.message.contains('safety')) {
//         return 'عذراً، تم حظر المحتوى لأسباب تتعلق بالسلامة. يرجى تعديل سؤالك.';
//       } else {
//         return 'خطأ في الاتصال بالمساعد: ${e.message}';
//       }
      
//     } catch (e) {
//       print('❌ خطأ غير متوقع: $e');
//       return 'حدث خطأ غير متوقع. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
//     }
//   }
// }


// services/gemini_service.dart
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   // استخدام متغير بيئة آمن (يفضل استخدام flutter_dotenv)
//   final String apiKey = 'AIzaSyCxIuV3_S4wuE2QW4-pMrSAt7bR1-6Um2M'; // استبدل بمفتاحك الحقيقي
  
//   Future<String> sendMessage(
//     String userMessage, {
//     String model = 'gemini-2.0-flash-exp',
//     double temperature = 0.7,
//   }) async {
//     try {
//       final GenerativeModel _model = GenerativeModel(
//         model: model,
//         apiKey: apiKey,
//         generationConfig: GenerationConfig(
//           temperature: temperature,
//           maxOutputTokens: 1000,
//           topP: 0.95,
//           topK: 40,
//         ),
//       );
      
//       final content = [Content.text(userMessage)];
//       final response = await _model.generateContent(content);
      
//       return response.text ?? 'لم يتم استلام رد من المساعد.';
//     } catch (e) {
//       print('Gemini Error: $e');
//       throw Exception('فشل في الاتصال بالمساعد: $e');
//     }
//   }
// }



// services/gemini_service.dart - النسخة النهائية
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
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
      print('❌ خطأ: $e');
      return 'حدث خطأ: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}';
    }
  }
}