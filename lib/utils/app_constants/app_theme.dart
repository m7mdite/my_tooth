import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient arcticFrostGradient = LinearGradient(
    colors: [
      Colors.white,
      Colors.white70,
      Colors.lightBlueAccent,
      Colors.blueAccent,
      // Colors.pinkAccent,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // // تدرج أزرق ثابت (لـ AppBar الرئيسي)
  // static const LinearGradient primaryGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF1E88E5), // أزرق ثابت
  //     Color(0xFF42A5F5), // أزرق فاتح
  //     Color(0xFF1565C0), // أزرق داكن
  //   ],
  //   stops: [0.0, 0.5, 1.0],
  // );

  // // تدرج أخضر نعناعي (للحالات الناجحة أو التوثيق)
  // static const LinearGradient successGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF26A69A),
  //     Color(0xFF4DB6AC),
  //     Color(0xFF00897B),
  //   ],
  // );

  // // تدرج أحمر رقيق (للتحذيرات أو الحذف)
  // static const LinearGradient errorGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFFEF5350),
  //     Color(0xFFE57373),
  //     Color(0xFFD32F2F),
  //   ],
  // );

  // // تدرج ذهبي (للمستخدمين المميزين أو الموثقين)
  // static const LinearGradient goldGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFFFFD54F),
  //     Color(0xFFFFC107),
  //     Color(0xFFFFB300),
  //   ],
  // );

  // static const LinearGradient rainbowMedicalGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF2193B0), // أزرق داكن
  //     Color(0xFF6DD5FA), // أزرق سماوي
  //     Color(0xFFFF758C), // وردي
  //     Color(0xFFFF7EB3), // وردي فاتح
  //     Color(0xFFF9D423), // ذهبي
  //     Colors.white,
  //   ],
  // );

  // static const LinearGradient sunsetSeaGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF005C97), // أزرق عميق
  //     Color(0xFF363795), // أزرق بنفسجي
  //     Color(0xFF8E2DE2), // أرجواني
  //     Color(0xFFFF512F), // برتقالي محمر
  //     Color(0xFFF09819), // برتقالي فاتح
  //     Colors.white,
  //   ],
  // );

  // static const LinearGradient mintFreshGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF1CB5E0), // أزرق سماوي
  //     Color(0xFF000046), // أزرق داكن جداً
  //     Color(0xFF00B4DB), // أزرق فاتح
  //     Color(0xFF11998E), // أخضر غامق
  //     Color(0xFF38EF7D), // أخضر نيون
  //     Colors.white,
  //   ],
  // );

  // static const LinearGradient vibrantNeonGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF0F2027), // رمادي غامق جداً مائل للأزرق
  //     Color(0xFF203A43), // أزرق-رمادي
  //     Color(0xFF2C5364), // أزرق معدني
  //     Color(0xFF00C9FF), // أزرق سماوي نيون
  //     Color(0xFF92FE9D), // أخضر نيون
  //     Color(0xFFFADB5F), // ذهبي فاتح
  //     Colors.white,
  //   ],
  //   stops: [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
  // );
  // static const LinearGradient freshAquaGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF00C9FF), // أزرق سماوي نيون
  //     Color(0xFF92FE9D), // أخضر فاتح
  //   ],
  // );

  // static const LinearGradient vibrantGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF4158D0), // أزرق بنفسجي غامق
  //     Color(0xFFC850C0), // أرجواني وردي
  //     Color(0xFFFFCC70), // أصفر ذهبي فاتح
  //   ],
  //   stops: [0.0, 0.5, 1.0],
  // );

  // static const LinearGradient mintBreezeGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF0B8793), // أخضر مزرق غامق (هادئ وعميق)
  //     Color(0xFF0F5B72), // أزرق مخضر داكن
  //     Color(0xFF1CB5E0), // أزرق سماوي فاتح (منعش)
  //     Color(0xFF4ECDC4), // تركواز ناعم (يشبه لون مياه البحر)
  //     Color(0xFFA8E6CF), // أخضر نعناعي فاتح جداً (نقاء)
  //     Color(0xFFF0FFF0), // أبيض مخضر (نضارة)
  //     Colors.white,
  //   ],
  //   stops: [0.0, 0.2, 0.4, 0.6, 0.8, 0.9, 1.0],
  // );
  // static const LinearGradient freshMintSplashGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF00B4DB), // أزرق سماوي نيون
  //     Color(0xFF11998E), // أخضر غامق غني
  //     Color(0xFF4ECDC4), // تركواز
  //     Color(0xFFA8E6CF), // نعناعي فاتح
  //     Color(0xFFD4F1F9), // أزرق شاحب جداً
  //     Colors.white,
  //   ],
  //   stops: [0.0, 0.3, 0.5, 0.7, 0.9, 1.0],
  // );

  // static const LinearGradient arcticMintGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF0B486B), // أزرق داكن عميق
  //     Color(0xFF3B8D99), // أزرق-أخضر معتدل
  //     Color(0xFF6EC7D6), // أزرق جليدي
  //     Color(0xFFA5D8D3), // نعناعي شاحب
  //     Color(0xFFE0F7FA), // أزرق مثلج
  //     Colors.white,
  //   ],
  // );
  // static const LinearGradient blueSerenityWaveGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     Color(0xFF0A3D62), // أزرق داكن عميق (يضفي عمقاً)
  //     Color(0xFF1E6FA9), // أزرق معتدل غني
  //     Color(0xFF3498DB), // أزرق سماوي كلاسيكي
  //     Color(0xFF6DD5FA), // أزرق فاتح جداً (كالسماء الصافية)
  //     Color(0xFFB3E5FC), // أزرق شاحب كالثلج
  //     Color(0xFFE3F2FD), // أزرق أبيض خفيف جداً
  //     Colors.white, // الأبيض الناصع في النهاية
  //   ],
  //   stops: [0.0, 0.2, 0.4, 0.6, 0.8, 0.9, 1.0],
  // );
  // static const LinearGradient electricIceGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF001F3F), // أزرق داكن جداً (كالحبر)
  //     Color(0xFF003366), // أزرق نيلي
  //     Color(0xFF0074D9), // أزرق نيون متوسط
  //     Color(0xFF7FDBFF), // أزرق جليدي فاتح
  //     Color(0xFFADD8E6), // أزرق فاتح جداً
  //     Color(0xFFF0F8FF), // أبيض أزرق (أليس)
  //     Colors.white,
  //   ],
  // );
}
