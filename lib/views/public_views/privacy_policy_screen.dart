import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/app_theme_constants.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "سياسة الخصوصية",
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.authBackground),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20,),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.primary, blurRadius: 20, spreadRadius: 1)
                    ],
                    color: AppColors.white.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Icon(Icons.privacy_tip_outlined, color: AppColors.white, size: 60),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    shadows: [Shadow(color: AppColors.white, blurRadius: 5)],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.95),
                  borderRadius: AppThemeConstants.borderRadius,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  boxShadow: [BoxShadow(color: AppColors.black12, blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicySection(
                      title: 'جمع المعلومات',
                      content: 'نحن نجمع المعلومات التي تقدمها عند إنشاء حساب، مثل الاسم، البريد الإلكتروني، الدور (طالب/مريض)، وغيرها. كما قد نجمع بعض البيانات المتعلقة بالاستخدام لتحسين الخدمة.',
                    ),
                    _buildDivider(),
                    _buildPolicySection(
                      title: 'استخدام المعلومات',
                      content: 'تُستخدم معلوماتك لتوفير الخدمات المطلوبة (الاستشارات، الطلبات، المحادثات) وتحسين تجربتك. لن يتم مشاركة معلوماتك مع أطراف ثالثة دون موافقتك إلا إذا اقتضى القانون ذلك.',
                    ),
                    _buildDivider(),
                    _buildPolicySection(
                      title: 'حماية البيانات',
                      content: 'نحن نتخذ إجراءات أمنية لحماية بياناتك من الوصول غير المصرح به. ومع ذلك، لا يمكن ضمان أمان البيانات المنقولة عبر الإنترنت بنسبة 100%.',
                    ),
                    _buildDivider(),
                    _buildPolicySection(
                      title: 'ملفات تعريف الارتباط',
                      content: 'نستخدم ملفات تعريف الارتباط لتحسين أداء التطبيق وتحليل الاستخدام. يمكنك تعطيلها من إعدادات متصفحك ولكن قد يؤثر ذلك على بعض الوظائف.',
                    ),
                    _buildDivider(),
                    _buildPolicySection(
                      title: 'حقوقك',
                      content: 'لديك الحق في الوصول إلى بياناتك وتصحيحها أو حذفها، ويمكنك التواصل معنا لطلب ذلك.',
                    ),
                    _buildDivider(),
                    _buildPolicySection(
                      title: 'التغييرات على السياسة',
                      content: 'قد نقوم بتحديث هذه السياسة بين الحين والآخر. سيتم إشعارك بأي تغييرات جوهرية عبر التطبيق.',
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.check_circle),
                        label: Text('وافقت وفهمت'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(1, 10),
                              topRight: Radius.elliptical(10, 1),
                              bottomLeft: Radius.elliptical(10, 1),
                              bottomRight: Radius.elliptical(1, 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: AppColors.black87, height: 1.3),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}