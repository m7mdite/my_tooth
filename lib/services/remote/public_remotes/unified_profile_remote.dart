import 'dart:io';
import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/api_link.dart';

class UnifiedProfileRemote {
  final Crud crud;
  UnifiedProfileRemote(this.crud);

  // جلب الملف الشخصي
   getMyProfile() async {
    final result = await crud.getData(ApiLink.profile);
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل الاتصال'},
      (data) => data,
    );
  }

  // تحديث الملف الشخصي
   updateProfile(Map<String, dynamic> data) async {
    final result = await crud.putData(ApiLink.profile, data, '');
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل الاتصال'},
      (data) => data,
    );
  }

  // رفع صورة البروفايل (PUT مع ملف)
   uploadProfilePicture(File image) async {
    final result = await crud.putDataWithFiles(
      ApiLink.photo,
      {},
      [image.path],
      'profile_photo',
    );
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل رفع الصورة'},
      (data) => data,
    );
  }

  // إرسال وثيقة التوثيق (POST مع ملف واحد)
   sendVerifyDocument(File image) async {
    final result = await crud.postDataWithFiles(
      ApiLink.verify,
      {},
      [image.path],
      'document', // اسم الحقل كما هو متوقع في الباك إند
    );
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل إرسال الوثيقة'},
      (data) => data,
    );
  }
}