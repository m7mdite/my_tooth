import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/auth_controllers/auth_controller.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
import 'login_form.dart';
import 'register_form.dart';

class AuthScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/images_asnan/asnan6.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // === الشعار والنص العلوي ===
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              // === أزرار التبويب ===
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Obx(
                  () => Row(
                    children: [
                      _buildTabButton(
                        label: "تسجيل الدخول",
                        isActive: controller.currentPage.value == 0,
                        onTap: () => controller.goToLogin(),
                      ),
                      _buildTabButton(
                        label: "إنشاء حساب",
                        isActive: controller.currentPage.value == 1,
                        onTap: () => controller.goToRegister(),
                      ),
                    ],
                  ),
                ),
              ),
              // === PageView مع أنيميشن ===
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.togglePage(index);
                  },
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    LoginForm(),
                    RegisterForm(),
                  ],
                ),
              ),
              // === زر تسجيل كضيف ===
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
                child: _buildGuestButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue.shade700 : Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== زر تسجيل كضيف =====
  Widget _buildGuestButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: AppThemeConstants.borderRadius,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          controller.loginAsGuest();
        },
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: Colors.white70,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              "الدخول كضيف",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}