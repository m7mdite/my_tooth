import 'package:get/get.dart';
import '../../controllers/theme_controller.dart'; // عدّل المسار حسب مكان الملف عندك

/// AppImages
/// -----------------------------------------------------------------
/// نفس فكرة AppColors بالضبط: الصور اللي المفروض تختلف حسب الثيم
/// (Dark / Pink / Blue) صارت static get بترجع المسار المناسب.
/// أي مكان بالكود يستخدم AppImages.authBackground بيضل هو هو،
/// بس الصورة يلي بترجع بتتغير حسب الثيم المختار.
/// -----------------------------------------------------------------
class AppImages {
  AppImages._();

  static AppThemeType get _theme => Get.isRegistered<ThemeController>()
      ? ThemeController.instance.currentTheme
      : AppThemeType.blue;

  /// خلفية شاشة تسجيل الدخول / إنشاء الحساب
  static String get authBackground {
    switch (_theme) {
      case AppThemeType.dark:
        return "images/images_asnan/aa3834e3-b727-425b-8556-6025c312cf46.jpeg";
      case AppThemeType.pink:
        return "images/images_asnan/b72d5768-c706-4146-aba1-9c1450bea5fa.jpeg";
      case AppThemeType.blue:
        return "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"; // نفس صورتك الحالية
    }
  }

  // أي خلفية ثانية بتحتاجها بالمستقبل (مثلاً خلفية splash) ضيفها هون
  // بنفس النمط:
  // static String get splashBackground {
  //   switch (_theme) {
  //     case AppThemeType.dark:
  //       return "images/splash_dark.png";
  //     case AppThemeType.pink:
  //       return "images/splash_pink.png";
  //     case AppThemeType.blue:
  //       return "images/splash_blue.png";
  //   }
  // }
}
