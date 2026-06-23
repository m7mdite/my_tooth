import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

// استيراد مكوناتك الخاصة (عدّل المسارات حسب مشروعك)
import '../../widgets/custom_app_bar.dart';
// import '../widgets/custom_app_bar.dart';
// import '../../app_route.dart';

class HomeScreenExample extends StatelessWidget {
  const HomeScreenExample({super.key});

  // بيانات وهمية للإحصائيات
  final int pendingCount = 3;
  final int processingCount = 2;
  final int completedCount = 5;
  final String userName = "أحمد";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الرئيسية",
        automaticallyImplyLeading: false,
        // صورة المستخدم (استخدم بياناتك الفعلية)
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Get.toNamed(AppRroute.notificationsView);
                  Get.snackbar("إشعارات", "سيتم فتح صفحة الإشعارات");
                },
              ),
              // عداد الإشعارات (مثال)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. بطاقة الترحيب + الإحصائيات
              _buildWelcomeCard(),

              SizedBox(height: 12),

              // 2. شبكة الوصول السريع
              _buildQuickActions(),

              SizedBox(height: 16),

              // 3. قائمة آخر النشاطات
              _buildRecentActivity(),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 1. بطاقة الترحيب (مع إحصائيات وهمية)
  // ============================================================
  Widget _buildWelcomeCard() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مرحباً $userName 👋",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "لديك ${pendingCount + processingCount} طلب نشط",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(Icons.medical_services, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("قيد الانتظار", pendingCount, Colors.orange),
                    _buildStatItem("قيد المعالجة", processingCount, Colors.blue),
                    _buildStatItem("مكتملة", completedCount, Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  // ============================================================
  // 2. شبكة الوصول السريع (4 خيارات)
  // ============================================================
  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'icon': Icons.add_circle, 'label': 'طلب جديد', 'color': Colors.blue, 'route': '/newRequest'},
      {'icon': Icons.chat, 'label': 'المحادثات', 'color': Colors.green, 'route': '/conversations'},
      {'icon': Icons.post_add, 'label': 'المنشورات', 'color': Colors.purple, 'route': '/feed'},
      {'icon': Icons.history, 'label': 'طلباتي', 'color': Colors.orange, 'route': '/myRequests'},
    ];

    return AnimationConfiguration.staggeredGrid(
      position: 1,
      duration: Duration(milliseconds: 600),
      columnCount: 2,
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: EdgeInsets.symmetric(horizontal: 16),
        childAspectRatio: 1.1,
        children: actions.map((action) {
          return SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: InkWell(
                onTap: () {
                  Get.snackbar("إجراء", "فتح: ${action['label']}");
                  // Get.toNamed(action['route']);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          size: 34,
                          color: action['color'] as Color,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        action['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // 3. قائمة آخر النشاطات (بيانات وهمية)
  // ============================================================
  Widget _buildRecentActivity() {
    final List<Map<String, String>> activities = [
      {'title': 'طلب علاج', 'subtitle': 'حالة: قيد الانتظار', 'time': 'منذ ساعة', 'route': '/request/1'},
      {'title': 'منشور جديد', 'subtitle': 'تم الإعجاب بـ 3 أشخاص', 'time': 'منذ 3 ساعات', 'route': '/post/1'},
      {'title': 'طلب مكتمل', 'subtitle': 'تمت المعالجة بنجاح', 'time': 'منذ يوم', 'route': '/request/2'},
    ];

    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "آخر النشاطات",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.snackbar("عرض الكل", "سيتم فتح صفحة النشاطات");
                      },
                      child: Text(
                        "عرض الكل",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ...activities.map((activity) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.history, color: Colors.blue),
                      ),
                      title: Text(
                        activity['title']!,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(activity['subtitle']!),
                      trailing: Text(
                        activity['time']!,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      onTap: () {
                        Get.snackbar("نشاط", "فتح: ${activity['title']}");
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}