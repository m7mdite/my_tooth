import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// أنواع الثيمات المتوفرة بالتطبيق
enum AppThemeType { blue, dark, pink }

/// ThemeController
/// -----------------------------------------------------------------
/// كونترولر بسيط يحفظ الثيم الحالي، يخزنه بالـ GetStorage عشان
/// يرجع نفسه لما المستخدم يفتح التطبيق من جديد، وينادي
/// Get.forceAppUpdate() عند التبديل عشان يعيد بناء كل الشجرة
/// (كل مكان مستخدم فيه AppColors.xxx رح ياخد القيمة الجديدة).
/// -----------------------------------------------------------------
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  final GetStorage _box = GetStorage();
  static const String _storageKey = 'app_theme';

  late AppThemeType currentTheme;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<String>(_storageKey);
    currentTheme = AppThemeType.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => AppThemeType.blue,
    );
  }

  bool get isDark => currentTheme == AppThemeType.dark;

  void changeTheme(AppThemeType theme) {
    if (currentTheme == theme) return;
    currentTheme = theme;
    _box.write(_storageKey, theme.name);
    // يعيد بناء كامل الشجرة عشان كل الودجت يلي بتستخدم AppColors
    // مباشرة (مش عن طريق Theme.of(context)) تتحدث فورًا.
    Get.forceAppUpdate();
  }
}
