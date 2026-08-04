import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gr_flutter/controllers/post_controllers/post_controller.dart';

import '../../../utils/app_constants/colors_constant.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController contentController = TextEditingController();
  final List<XFile> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  final PostController controller = Get.find();

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void submit() async {
    if (contentController.text.trim().isEmpty && selectedImages.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال نص أو اختيار صورة');
      return;
    }
    List<String> paths = selectedImages.map((img) => img.path).toList();
    await controller.createPost(contentController.text.trim(), paths);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'نشر منشور جديد',
        centerTitle: true,
        actions: [
          Obx(() => TextButton(
                onPressed: controller.isCreating.value ? null : submit,
                child: const Text('نشر', style: TextStyle(color: AppColors.white)),
              )),
        ],
      ),
      body: Obx(() => controller.isCreating.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'اكتب ما تريد مشاركته...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selectedImages.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(selectedImages[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  onPressed: () => removeImage(index),
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
                    icon: const Icon(Icons.photo_library),
                    label: const Text('إضافة صور'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey200,
                        foregroundColor: AppColors.black),
                  ),
                ],
              ),
            )),
    );
  }
}
