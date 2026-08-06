import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart'; // عدّل المسار حسب مكان الملف عندك

/// AppColors
/// -----------------------------------------------------------------
/// كل الألوان المستخدمة في التطبيق مجمّعة هنا في مكان واحد.
/// بدل ما تكتب Colors.blue أو Color(0xFF4A90D9) بشكل مباشر بأي ملف،
/// استخدم AppColors.primary أو AppColors.onboardingBlueStart ...الخ
///
/// ملاحظة مهمة بعد إضافة الثيمات:
/// الألوان اللي لازم تتغير حسب الثيم (blue / dark / pink) تحولت من
/// `static const` إلى `static get` بترجع قيمة مختلفة حسب الثيم الحالي
/// المخزّن بـ ThemeController. الاستخدام بباقي الملفات ما تغيّر إطلاقًا:
/// AppColors.primary لسا AppColors.primary، بس صار "ذكي".
/// -----------------------------------------------------------------
class AppColors {
  AppColors._(); // منع إنشاء instance من الكلاس

  // يرجع الثيم الحالي، وإذا الكونترولر لسا مو مسجل (نادرًا) يرجع blue كافتراضي
  static AppThemeType get _theme => Get.isRegistered<ThemeController>()
      ? ThemeController.instance.currentTheme
      : AppThemeType.blue;

  static bool get isDark => _theme == AppThemeType.dark;

  // =========================================================
  // 1) الألوان الأساسية (Brand / Primary) -- بتتغير حسب الثيم
  // =========================================================
  static const MaterialColor _blackMaterial = MaterialColor(
  0xFF000000,
  <int, Color>{
    50:  Color(0xFF424242),
    100: Color(0xFF383838),
    200: Color(0xFF2E2E2E),
    300: Color(0xFF242424),
    400: Color(0xFF1A1A1A),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
  static MaterialColor get primary {
    switch (_theme) {
      case AppThemeType.dark:
        return _blackMaterial;
      case AppThemeType.pink:
        return Colors.pink;
      case AppThemeType.blue:
        return Colors.blue;
    }
  }

  static Color get primaryAccent {
    switch (_theme) {
      case AppThemeType.dark:
        return Colors.blueGrey.shade200;
      case AppThemeType.pink:
        return Colors.pinkAccent;
      case AppThemeType.blue:
        return Colors.blueAccent;
    }
  }

  static Color get primaryLightAccent {
    switch (_theme) {
      case AppThemeType.dark:
        return Colors.indigo.shade200;
      case AppThemeType.pink:
        return Colors.pink.shade100;
      case AppThemeType.blue:
        return Colors.lightBlueAccent;
    }
  }

  // =========================================================
  // 1.ب) ألوان الخلفيات والسطوح -- جديدة، ضرورية للـ Dark Mode
  // هاي أهم إضافة: بدون هاي، خلفية الشاشات رح تضل بيضا حتى
  // بالثيم الغامق إذا كانت الشاشات مستخدمة AppColors.white مباشرة.
  // =========================================================
  static Color get background {
    switch (_theme) {
      case AppThemeType.dark:
        return const Color(0xFF121212);
      case AppThemeType.pink:
        return const Color(0xFFFFF5F8);
      case AppThemeType.blue:
        return Colors.white;
    }
  }

  static Color get surface {
    switch (_theme) {
      case AppThemeType.dark:
        return const Color(0xFFFFFFFF);
      case AppThemeType.pink:
        return const Color(0xFFFFFFFF);
      case AppThemeType.blue:
        return Colors.white;
    }
  }

  static Color get cardColor {
    switch (_theme) {
      case AppThemeType.dark:
        return const Color(0xFF242424);
      case AppThemeType.pink:
        return const Color(0xFFFFECF2);
      case AppThemeType.blue:
        return Colors.white;
    }
  }

  static Color get textPrimary {
    switch (_theme) {
      case AppThemeType.dark:
        return Colors.white;
      case AppThemeType.pink:
      case AppThemeType.blue:
        return Colors.black87;
    }
  }

  static Color get textSecondary {
    switch (_theme) {
      case AppThemeType.dark:
        return Colors.white70;
      case AppThemeType.pink:
      case AppThemeType.blue:
        return Colors.black54;
    }
  }

  static Color get borderColor {
    switch (_theme) {
      case AppThemeType.dark:
        return Colors.white24;
      case AppThemeType.pink:
        return Colors.pink.shade100;
      case AppThemeType.blue:
        return Colors.grey.shade300;
    }
  }

  // =========================================================
  // 2) الألوان المحايدة (Neutrals) -- ثابتة، ما إلها علاقة بالثيم
  // (خليتها زي ما هي لأنها مستخدمة كألوان "حرفية" بأماكن كتير،
  // مو بالضرورة background/text. راجع القسم 1.ب فوق للبدائل
  // المرتبطة بالثيم)
  // =========================================================
  static const Color white = Colors.white;
  static const Color white54 = Colors.white54;
  static const Color white70 = Colors.white70;
  static const Color white24 = Colors.white24;
  static const Color white60 = Colors.white60;
  static const Color black = Colors.black;
  static const Color black54 = Colors.black54;
  static const Color black87 = Colors.black87;
  static const Color black12 = Colors.black12;
  static const Color black26 = Colors.black26;
  static const Color transparent = Colors.transparent;

  // =========================================================
  // 3) درجات الرمادي (Grey Scale)
  // =========================================================
  static const MaterialColor grey = Colors.grey;
  static final Color grey50 = grey[50]!;
  static final Color grey100 = grey.shade100;
  static final Color grey200 = grey[200]!;
  static final Color grey300 = grey.shade300;
  static final Color grey400 = grey[400]!;
  static final Color grey500 = grey[500]!;
  static final Color grey600 = grey[600]!;
  static final Color grey700 = grey[700]!;
  static final Color grey900 = grey[900]!;

  // =========================================================
  // 4) درجات لون البراند (Primary Shades) -- صارت تتبع الثيم تلقائيًا
  // لأنها مبنية فوق primary اللي فوق صار getter
  // =========================================================
  static Color get primary50 => primary[100]!;
  static Color get primary100 => primary[100]!;
  static Color get primary200 => primary[200]!;
  static Color get primary300 => primary[300]!;
  static Color get primary400 => primary[400]!;
  static Color get primary500 => primary[500]!;
  static Color get primary600 => primary[600]!;
  static Color get primary700 => primary[700]!;
  static Color get primary800 => primary[800]!;

  // =========================================================
  // 5) ألوان دلالية (Semantic Colors) -- عادة ثابتة بكل الثيمات
  // (نجاح/خطأ/تحذير بلازم يضلوا مفهومين بغض النظر عن الثيم)
  // =========================================================
  static const MaterialColor success = Colors.green;
  static const Color successAccent = Colors.greenAccent;
  static final Color successLight = Colors.green.shade50;
  static final Color successDark = Colors.green.shade700;

  static const MaterialColor error = Colors.red;
  static final Color error100 = Colors.red[100]!;
  static const Color errorAccent = Colors.redAccent;

  static const MaterialColor warning = Colors.orange;
  static final Color warningDark = Colors.orange.shade700;

  // =========================================================
  // 6) ألوان إضافية مستخدمة بأماكن متفرقة بالمشروع
  // =========================================================
  static const Color teal = Colors.teal;
  static const MaterialColor purple = Colors.purple;
  static const Color pink = Colors.pink;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color indigo = Colors.indigo;
  static const MaterialColor deepPurple = Colors.deepPurple;
  static const MaterialColor amber = Colors.amber;
  static const MaterialColor lightGreen = Colors.lightGreen;
  static const Color lightGreenAccent = Colors.lightGreenAccent;
  static const Color greenAccent = Colors.greenAccent;

  // =========================================================
  // 7) ألوان شاشة الـ Onboarding
  // =========================================================
  static const Color onboarding1Start = Color(0xFF4A90D9);
  static const Color onboarding1End = Color(0xFF74B9FF);

  static const Color onboarding2Start = Color(0xFF00B894);
  static const Color onboarding2End = Color(0xFF55EFC4);

  static const Color onboarding3Start = Color(0xFF6C5CE7);
  static const Color onboarding3End = Color(0xFFA29BFE);

  static const Color onboarding4Start = Color(0xFFE17055);
  static const Color onboarding4End = Color(0xFFFAB1A0);
}

// import 'package:flutter/material.dart';

// /// AppColors
// /// -----------------------------------------------------------------
// /// كل الألوان المستخدمة في التطبيق مجمّعة هنا في مكان واحد.
// /// بدل ما تكتب Colors.blue أو Color(0xFF4A90D9) بشكل مباشر بأي ملف،
// /// استخدم AppColors.primary أو AppColors.onboardingBlueStart ...الخ
// ///
// /// أي تغيير للون بالمستقبل => تغيير سطر واحد هون بس، وينعكس بكل الشاشات.
// /// -----------------------------------------------------------------
// class AppColors {
//   AppColors._(); // منع إنشاء instance من الكلاس

//   // =========================================================
//   // 1) الألوان الأساسية (Brand / Primary)
//   // =========================================================
//   static const MaterialColor  primary = Colors.blue;
//   // static const Color  primary = Colors.blue;
//   // static final Color primary50 = primaryMaterial[100]!;
//   static const Color primaryAccent = Colors.blueAccent;
//   static const Color primaryLightAccent = Colors.lightBlueAccent;

//   // =========================================================
//   // 2) الألوان المحايدة (Neutrals)
//   // =========================================================
//   static const Color white = Colors.white;
//   static const Color white54 = Colors.white54;
//   static const Color white70 = Colors.white70;
//   static const Color white24 = Colors.white24;
//   static const Color white60 = Colors.white60;
//   static const Color black = Colors.black;
//   static const Color black54 = Colors.black54;
//   static const Color black87 = Colors.black87;
//   static const Color black12 = Colors.black12;
//   static const Color black26 = Colors.black26;
//   static const Color transparent = Colors.transparent;

//   // =========================================================
//   // 3) درجات الرمادي (Grey Scale) - حسب المستخدم فعليًا بالمشروع
//   // =========================================================
//   static const MaterialColor grey = Colors.grey;
//   static final Color grey50 = grey[50]!;
//   static final Color grey100 = grey.shade100;
//   static final Color grey200 = grey[200]!;
//   static final Color grey300 = grey.shade300;
//   static final Color grey400 = grey[400]!;
//   static final Color grey500 = grey[500]!;
//   static final Color grey600 = grey[600]!;
//   static final Color grey700 = grey[700]!;
//   static final Color grey900 = grey[900]!;

//   // =========================================================
//   // 4) درجات الأزرق (Blue Shades) - مستخدمة بكثرة بالمشروع
//   // =========================================================
//   static final Color primary50 = primary[100]!;
//   static final Color primary100 = primary[100]!;
//   static final Color primary200 = primary[200]!;
//   static final Color primary300 = primary[300]!;
//   static final Color primary400 = primary[400]!;
//   static final Color primary500 = primary[500]!;
//   static final Color primary600 = primary[600]!;
//   static final Color primary700 = primary[700]!;
//   static final Color primary800 = primary[800]!;

//   // =========================================================
//   // 5) ألوان دلالية (Semantic Colors)
//   // =========================================================
//   // نجاح / تأكيد
//   static const MaterialColor success = Colors.green;
//   static const Color successAccent = Colors.greenAccent;
//   static final Color successLight = Colors.green.shade50;
//   static final Color successDark = Colors.green.shade700;

//   // خطأ / حذف
//   static const MaterialColor error = Colors.red;
//   static final Color error100 = Colors.red[100]!;
//   static const Color errorAccent = Colors.redAccent;

//   // تحذير
//   static const MaterialColor warning = Colors.orange;
//   static final Color warningDark = Colors.orange.shade700;

//   // =========================================================
//   // 6) ألوان إضافية مستخدمة بأماكن متفرقة بالمشروع
//   // =========================================================
//   static const Color teal = Colors.teal;
//   static const MaterialColor purple = Colors.purple;
//   static const Color pink = Colors.pink;
//   static const Color pinkAccent = Colors.pinkAccent;
//   static const Color indigo = Colors.indigo;
//   static const MaterialColor deepPurple = Colors.deepPurple;
//   static const MaterialColor amber = Colors.amber;
//   static const MaterialColor lightGreen = Colors.lightGreen;
//   static const Color lightGreenAccent = Colors.lightGreenAccent;
//   static const Color greenAccent = Colors.greenAccent;

//   // =========================================================
//   // 7) ألوان شاشة الـ Onboarding (كانت Color(0xFF..) مباشرة)
//   // =========================================================
//   // الشاشة 1: الأمان
//   static const Color onboarding1Start = Color(0xFF4A90D9);
//   static const Color onboarding1End = Color(0xFF74B9FF);

//   // الشاشة 2: المعالجات المجانية
//   static const Color onboarding2Start = Color(0xFF00B894);
//   static const Color onboarding2End = Color(0xFF55EFC4);

//   // الشاشة 3: التواصل والمرونة
//   static const Color onboarding3Start = Color(0xFF6C5CE7);
//   static const Color onboarding3End = Color(0xFFA29BFE);

//   // الشاشة 4: التصميم والكفاءة
//   static const Color onboarding4Start = Color(0xFFE17055);
//   static const Color onboarding4End = Color(0xFFFAB1A0);
// }
