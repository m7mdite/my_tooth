import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:lottie/lottie.dart';
import '../../../app_route.dart';
import '../../widgets/custom_app_bar.dart';

class HomeScreenPro extends StatefulWidget {
  const HomeScreenPro({super.key});

  @override
  State<HomeScreenPro> createState() => _HomeScreenProState();
}

class _HomeScreenProState extends State<HomeScreenPro> with SingleTickerProviderStateMixin {
  // بيانات وهمية
  final int pendingCount = 3;
  final int processingCount = 2;
  final int completedCount = 8;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "",
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(AppConstants.defaultBackgroundImage)
                ),
              ),
            );
          },
        ),
        actions: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () => Get.toNamed(AppRroute.notificationsView),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '5',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade100,
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => Future.delayed(Duration(seconds: 1)),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // ===== بطاقة الترحيب مع Lottie =====
                  _buildWelcomeCard().animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
                  SizedBox(height: 20),

                  // ===== إحصائيات سريعة =====
                  _buildStatsRow().animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  SizedBox(height: 24),

                  // ===== عنوان الإجراءات السريعة =====
                  Text(
                    "الإجراءات السريعة",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideX(begin: -0.1),
                  SizedBox(height: 12),

                  // ===== شبكة الإجراءات السريعة (أيقونات متحركة) =====
                  _buildQuickActionsGrid().animate().fadeIn(delay: 300.ms, duration: 600.ms),
                  SizedBox(height: 24),

                  // ===== عنوان آخر النشاطات =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "آخر النشاطات",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/all_activities'),
                        child: Text("عرض الكل", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideX(begin: 0.1),
                  SizedBox(height: 8),

                  // ===== قائمة النشاطات =====
                  _buildActivityList().animate().fadeIn(delay: 600.ms, duration: 600.ms),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== 1. بطاقة الترحيب مع Lottie =====
  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.5),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مرحباً أحمد 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "لديك ${pendingCount + processingCount} طلب نشط",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildMiniStat("قيد الانتظار", pendingCount, Colors.orange),
                    SizedBox(width: 16),
                    _buildMiniStat("قيد المعالجة", processingCount, Colors.blue.shade200),
                    SizedBox(width: 16),
                    _buildMiniStat("مكتملة", completedCount, Colors.green.shade200),
                  ],
                ),
              ],
            ),
          ),
          Lottie.asset(
            'assets/animations/doctor.json',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  // ===== 2. صف الإحصائيات =====
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard("طلبات اليوم", "12", Icons.today),
        SizedBox(width: 12),
        _buildStatCard("مشاهدات", "45", Icons.visibility),
        SizedBox(width: 12),
        _buildStatCard("تقييم", "4.8", Icons.star),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue.shade700),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 3. شبكة الإجراءات السريعة (Neumorphism) =====
  Widget _buildQuickActionsGrid() {
    final actions = [
      {'icon': Icons.add_circle, 'label': 'طلب جديد', 'color': Colors.blue, 'route': '/newRequest'},
      {'icon': Icons.chat, 'label': 'محادثة', 'color': Colors.green, 'route': '/conversations'},
      {'icon': Icons.post_add, 'label': 'منشور', 'color': Colors.purple, 'route': '/feed'},
      {'icon': Icons.history, 'label': 'طلباتي', 'color': Colors.orange, 'route': '/myRequests'},
      {'icon': Icons.medical_services, 'label': 'خدمات', 'color': Colors.teal, 'route': '/services'},
      {'icon': Icons.settings, 'label': 'إعدادات', 'color': Colors.grey, 'route': '/settings'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildNeumorphismCard(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          color: action['color'] as Color,
          onTap: () => Get.snackbar("إجراء", "فتح: ${action['label']}"),
        );
      },
    );
  }

  Widget _buildNeumorphismCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(-4, -4),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ===== 4. قائمة آخر النشاطات =====
  Widget _buildActivityList() {
    final activities = [
      {'title': 'طلب علاج جديد', 'subtitle': 'حالة: قيد الانتظار', 'time': 'منذ ساعة', 'icon': Icons.medical_services},
      {'title': 'تم الموافقة على منشورك', 'subtitle': 'بوست عن صحة الأسنان', 'time': 'منذ 3 ساعات', 'icon': Icons.post_add},
      {'title': 'طلب مكتمل', 'subtitle': 'معالجة الجذر', 'time': 'منذ يوم', 'icon': Icons.check_circle},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final act = activities[index];
        return _buildActivityTile(act);
      },
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> act) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(act['icon'] as IconData, color: Colors.blue.shade700),
        ),
        title: Text(
          act['title'] as String,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(act['subtitle'] as String),
        trailing: Text(act['time'] as String, style: TextStyle(color: Colors.grey, fontSize: 12)),
        onTap: () => Get.snackbar("نشاط", "فتح: ${act['title']}"),
      ),
    );
  }
}