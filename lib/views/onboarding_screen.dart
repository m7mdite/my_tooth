import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

import '../services/local_storge/local_user_storage.dart';
import '../utils/app_constants/colors_constant.dart';
import '../utils/app_constants/onboarding_constants.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxDouble parallaxOffset = 0.0.obs;
      final localStorage = Get.find<LocalUserStorage>();


  @override
  void onInit() {
    pageController = PageController(viewportFraction: 0.9);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void goToPage(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void nextPage() async{
    if (currentPage.value < 3) {
      goToPage(currentPage.value + 1);
    } else {
      await localStorage.saveSeenOnboarding();
      Get.offAllNamed(AppRroute.auth);
    }
  }

  void skip() {
    Get.offAllNamed(AppRroute.auth);
  }
}

// ============================================================
// الصفحة الرئيسية
// ============================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController controller = Get.put(OnboardingController());
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ===== خلفية متحركة مع أمواج =====
          _AnimatedWaveBackground(waveAnimation: _waveAnimation),

          // ===== صفحة التمرير =====
          PageView.builder(
            controller: controller.pageController,
            itemCount: OnboardingConstants.items.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final item = OnboardingConstants.items[index];
              final isActive = controller.currentPage.value == index;
              return _OnboardingPage(
                item: item,
                index: index,
                isActive: isActive,
                controller: controller,
              );
            },
          ),

          // ===== الأزرار والمؤشرات (تظل ثابتة فوق الصفحات) =====
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // نقاط المؤشر
                Obx(
                  () => Row(
                    children: List.generate(OnboardingConstants.items.length, (index) {
                      final isActive = controller.currentPage.value == index;
                      return _buildDot(index, isActive);
                    }),
                  ),
                ),

                // زر التالي / ابدأ
                Obx(
                  () => _buildNextButton(
                    isLast: controller.currentPage.value == 3,
                    onTap: controller.nextPage,
                  ),
                ),
              ],
            ),
          ),

          // زر التخطي
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: controller.skip,
              child: Text(
                "تخطي",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(blurRadius: 8, color: AppColors.black26)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== نقطة المؤشر مع حركة =====
  Widget _buildDot(int index, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [AppColors.primary700, AppColors.primary400],
              )
            : null,
        color: isActive ? null : AppColors.grey300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary400.withOpacity(0.4),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
    );
  }

  // ===== زر التالي / ابدأ مع حركة =====
  Widget _buildNextButton({required bool isLast, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.95, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLast
                      ? [AppColors.success.shade600, AppColors.success.shade400]
                      : [AppColors.primary700, AppColors.primary500],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (isLast
                            ? AppColors.success.shade400
                            : AppColors.primary400)
                        .withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLast ? "ابدأ الآن" : "التالي",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 400),
                    turns: isLast ? 1 : 0,
                    child: Icon(
                      isLast ? Icons.check_circle : Icons.arrow_forward_ios,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// خلفية أمواج متحركة (CustomPaint)
// ============================================================
class _AnimatedWaveBackground extends StatelessWidget {
  final Animation<double> waveAnimation;

  const _AnimatedWaveBackground({required this.waveAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: waveAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(waveValue: waveAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double waveValue;

  _WavePainter({required this.waveValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primary700,
          AppColors.primary500,
          AppColors.primary300,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // رسم أمواج
    final path = Path();
    final waveHeight = 50.0;
    final waveWidth = size.width;

    path.moveTo(0, size.height * 0.6);

    for (double i = 0; i < waveWidth; i++) {
      double y = waveHeight * sin(i / 20 + waveValue * 2 * 3.14159) +
          size.height * 0.6;
      path.lineTo(i, y);
    }

    path.lineTo(waveWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================
// صفحة التعريف (مع حركات متعددة)
// ============================================================
class _OnboardingPage extends StatefulWidget {
  final OnboardingItem item;
  final int index;
  final bool isActive;
  final OnboardingController controller;

  const _OnboardingPage({
    required this.item,
    required this.index,
    required this.isActive,
    required this.controller,
  });

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ===== الصورة مع حركة الطفو =====
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: screenHeight * 0.42,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: AppThemeConstants.borderRadius,
                    border: Border.all(color: AppColors.white,strokeAlign: 10),
                    image: DecorationImage(
                      image: AssetImage(widget.item.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // ===== نص العنوان مع حركة =====
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, (1 - opacity) * 30),
                  child: child,
                ),
              );
            },
            child: Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                shadows: [Shadow(blurRadius: 6, color: AppColors.black26)],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),

          // ===== نص الوصف مع حركة =====
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, (1 - opacity) * 40),
                  child: child,
                ),
              );
            },
            child: Text(
              widget.item.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}