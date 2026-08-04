import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/models/posts_models/post_model.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;
  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController contentController;
  List<XFile> newImages = [];
  List<String> deleteImageIds = [];
  final ImagePicker picker = ImagePicker();
  final PostController controller = Get.find();

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => newImages.addAll(images));
    }
  }

  void removeExistingImage(int index) {
    setState(() {
      final image = widget.post.images![index];
      if (image.publicId != null) {
        deleteImageIds.add(image.publicId!);
      }
      widget.post.images!.removeAt(index);
    });
  }

  void removeNewImage(int index) {
    setState(() => newImages.removeAt(index));
  }

  void submit() async {
    if (contentController.text.trim().isEmpty && widget.post.images!.isEmpty && newImages.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال نص أو اختيار صورة');
      return;
    }
    await controller.updatePost(
      postId: widget.post.sId!,
      newContent: contentController.text.trim(),
      newImagePaths: newImages.map((img) => img.path).toList(),
      deleteImageIds: deleteImageIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'تعديل المنشور',
        actions: [
          TextButton(
            onPressed: submit,
            child: const Text('حفظ', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'عدل المحتوى...'),
            ),
            const SizedBox(height: 16),
            // الصور الحالية
            if (widget.post.images!.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.post.images!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.post.images![index].url!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => removeExistingImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            // الصور الجديدة
            if (newImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(newImages[index].path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => removeNewImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('إضافة صور'),
            ),
          ],
        ),
      ),
    );
  }
}