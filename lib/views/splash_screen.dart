import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/local_storge/local_user_storage.dart';

import '../services/notification/websocket_service.dart';
import '../utils/app_constants/colors_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Future<void> _checkLoginStatus() async {
  //   // الانتظار قليلاً لتأثير بصري
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   final storage = Get.find<LocalUserStorage>();
  //   final token = await storage.getToken();
  //   final role = await storage.getRole();
  //   final hasSeenOnboarding = await storage.hasSeenOnboarding();
  //   print("$token");
  //   print("$role");
  //   print(  "$hasSeenOnboarding");
  //   if (!hasSeenOnboarding) {
  //     Get.offAllNamed(AppRroute.onboarding);
  //   } else if (token != null && token.isNotEmpty) {

  //     // يوجد توكن → انتقل إلى الصفحة المناسبة حسب الدور
  //     _navigateToHome(role);
  //   } else {
  //     // لا يوجد توكن → انتقل إلى صفحة التسجيل
  //     Get.offAllNamed(AppRroute.auth);
  //   }
  // }
  Future<void> _checkLoginStatus() async {
  await Future.delayed(const Duration(milliseconds: 500));

  final storage = Get.find<LocalUserStorage>();
  final token = await storage.getToken();
  final role = await storage.getRole();
  final hasSeenOnboarding = await storage.hasSeenOnboarding();
  print("$token");
  print("$role");
  print("$hasSeenOnboarding");

  if (!hasSeenOnboarding) {
    Get.offAllNamed(AppRroute.onboarding);
  } else if (token != null && token.isNotEmpty) {
    // ✅ أعد الاتصال بالـ WebSocket إذا في توكن
    final userId = storage.getId();
    if (userId != null && userId.isNotEmpty) {
      Get.find<WebSocketService>().connect(userId);
    }
    _navigateToHome(role);
  } else {
    Get.offAllNamed(AppRroute.auth);
  }
}

  void _navigateToHome(String? role) {
    switch (role) {
      case 'admin':
        Get.offAllNamed(AppRroute.mainScreenAdmin);
        break;
      case 'student':
        Get.offAllNamed(AppRroute.mainScreenStudent);
        break;
      case 'patient':
        Get.offAllNamed(AppRroute.mainScreenPatient);
        break;
      case 'overseer':
        Get.offAllNamed(AppRroute.mainScreenOverseer);
        break;
      default:
        Get.offAllNamed(AppRroute.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary700, AppColors.primary300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // هنا يمكنك وضع شعار التطبيق
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: AppColors.white,
              ),
              const SizedBox(height: 20),
              Text(
                'My Tooth',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: AppColors.white,
              ),
              const SizedBox(height: 20),
              Text(
                'جاري التحميل...',
                style: TextStyle(color: AppColors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
