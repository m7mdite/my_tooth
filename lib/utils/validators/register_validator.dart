import 'package:flutter/material.dart';

class RegisterValidator {
  // التحقق من أن الحقل غير فارغ
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'حقل $fieldName مطلوب';
    }
    return null;
  }

  // التحقق من البريد الإلكتروني
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  // التحقق من كلمة المرور (على الأقل 6 أحرف)
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.trim().length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  // التحقق من تطابق كلمة المرور مع التأكيد
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  // التحقق من الرقم الجامعي (للطلاب فقط - اختياري لكن يمكن أن يكون له شروط)
  static String? universityNumber(String? value, bool isStudent) {
    if (isStudent && (value == null || value.trim().isEmpty)) {
      return 'الرقم الجامعي مطلوب للطلاب';
    }
    // يمكن إضافة تحقق إضافي مثل ألا يقل عن 4 أرقام
    if (value != null && value.trim().isNotEmpty && value.trim().length < 4) {
      return 'الرقم الجامعي يجب أن يكون 4 أرقام على الأقل';
    }
    return null;
  }

  // التحقق من الاسم (حروف فقط)
  static String? name(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'حقل $fieldName مطلوب';
    }
    final nameRegex = RegExp(r'^[\u0621-\u064A\s]+$'); // حروف عربية ومسافات
    if (!nameRegex.hasMatch(value.trim())) {
      return 'يجب أن يحتوي $fieldName على أحرف عربية فقط';
    }
    return null;
  }
}