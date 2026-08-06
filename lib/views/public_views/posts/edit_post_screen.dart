import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';
import 'package:gr_flutter/models/posts_models/post_model.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../controllers/theme_controller.dart';
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
      if (image.publicId != null) deleteImageIds.add(image.publicId!);
      widget.post.images!.removeAt(index);
    });
  }

  void removeNewImage(int index) {
    setState(() => newImages.removeAt(index));
  }

  void submit() async {
    if (contentController.text.trim().isEmpty &&
        widget.post.images!.isEmpty &&
        newImages.isEmpty) {
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
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          appBar: CustomAppBar(
            title: 'تعديل المنشور',
            actions: [
              TextButton(
                onPressed: submit,
                child:
                    const Text('حفظ', style: TextStyle(color: AppColors.white)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== حقل النص =====
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface, // ✅
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor), // ✅
                  ),
                  child: TextField(
                    controller: contentController,
                    maxLines: 5,
                    style: TextStyle(color: AppColors.textPrimary), // ✅
                    decoration: InputDecoration(
                      hintText: 'عدل المحتوى...',
                      hintStyle:
                          TextStyle(color: AppColors.textSecondary), // ✅
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ===== الصور الحالية =====
                if (widget.post.images!.isNotEmpty)
                  _imageRow(
                    itemCount: widget.post.images!.length,
                    imageBuilder: (index) => Image.network(
                      widget.post.images![index].url!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    onRemove: removeExistingImage,
                  ),

                const SizedBox(height: 16),

                // ===== الصور الجديدة =====
                if (newImages.isNotEmpty)
                  _imageRow(
                    itemCount: newImages.length,
                    imageBuilder: (index) => Image.file(
                      File(newImages[index].path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    onRemove: removeNewImage,
                  ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('إضافة صور'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // ✅
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageRow({
    required int itemCount,
    required Widget Function(int) imageBuilder,
    required void Function(int) onRemove,
  }) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageBuilder(index),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => onRemove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.error, // ✅
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 16, color: AppColors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
