import 'package:flutter/material.dart';
import '../../controllers/theme_controller.dart'; // عدّل المسار حسب مكان الملف عندك

/// ودجت بسيطة تحطها بشاشة الإعدادات/البروفايل
/// تعرض 3 دوائر ألوان (أزرق / غامق / وردي) وتبدّل الثيم عند الضغط
class ThemeSwitcherWidget extends StatelessWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;

    Widget colorCircle(AppThemeType type, Color color) {
      final bool selected = controller.currentTheme == type;
      return GestureDetector(
        onTap: () => controller.changeTheme(type),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? Colors.black : Colors.transparent,
              width: 3,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        colorCircle(AppThemeType.blue, Colors.blue),
        colorCircle(AppThemeType.dark, const Color(0xFF121212)),
        colorCircle(AppThemeType.pink, Colors.pink),
      ],
    );
  }
}
