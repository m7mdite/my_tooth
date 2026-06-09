import 'dart:io';
import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/remote/crud.dart';

class StudentRemote {
  final Crud crud;
  StudentRemote(this.crud);

   sendVerifyDocument(File image) async {
    final result = await crud.postDataWithFiles(
      ApiLink.verify,
      {},
      [image.path],
      'document',
    );
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل إرسال الوثيقة'},
      (data) => data,
    );
  }
}