// constants/onboarding_constants.dart
import 'package:flutter/material.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;
  final Color color1;
  final Color color2;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
  });
}

class OnboardingConstants {
  static List<OnboardingItem> items = [
    OnboardingItem(
      image: "images/onboarding/onboarding1.png",
      title: "أسنانك في أمان تام",
      description: "بيئة رقمية آمنة تحافظ على خصوصية بياناتك وتوفر لك رعاية متكاملة لأسنانك مع أعلى معايير الأمان",
      color1: Color(0xFF4A90D9),
      color2: Color(0xFF74B9FF),
    ),
    OnboardingItem(
      image: "images/onboarding/onboarding2.png",
      title: "معالجات مجانية بمستوى أكاديمي",
      description: "استشر أفضل أطباء الأسنان في بيئة جامعية متطورة، حيث تتوفر لك المعالجات مجاناً وبجودة أكاديمية عالية",
      color1: Color(0xFF00B894),
      color2: Color(0xFF55EFC4),
    ),
    OnboardingItem(
      image: "images/onboarding/onboarding3.png",
      title: "سهولة في التواصل ومرونة في التعامل",
      description: "تواصل مباشر مع المشرفين والطلاب، وادارة طلباتك بسلاسة، وبيئة تفاعلية تتيح لك المتابعة في أي وقت",
      color1: Color(0xFF6C5CE7),
      color2: Color(0xFFA29BFE),
    ),
    OnboardingItem(
      image: "images/onboarding/onboarding4.png",
      title: "تصميم أنيق وكفاءة عالية",
      description: "تجربة مستخدم متميزة بلمسات جمالية عصرية، مع ضمان أعلى درجات الكفاءة والدقة الأكاديمية في كل خطوة",
      color1: Color(0xFFE17055),
      color2: Color(0xFFFAB1A0),
    ),
  ];
}