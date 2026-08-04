import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/unified_setting_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'dart:io';

import '../../../services/local_storge/local_user_storage.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';

class UnifiedEditProfileScreen extends StatefulWidget {
  const UnifiedEditProfileScreen({super.key});

  @override
  _UnifiedEditProfileScreenState createState() => _UnifiedEditProfileScreenState();
}

class _UnifiedEditProfileScreenState extends State<UnifiedEditProfileScreen> {
  final UnifiedSettingController controller = Get.find();
  final localStorage = Get.find<LocalUserStorage>();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController fatherNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController universityNumberController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: localStorage.getFirstName() ?? '');
    fatherNameController = TextEditingController(text: localStorage.getFatherName() ?? '');
    lastNameController = TextEditingController(text: localStorage.getLastName() ?? '');
    phoneController = TextEditingController(text: controller.phoneNumber.value);
    bioController = TextEditingController(text: controller.bio.value);
    ageController = TextEditingController(text: controller.age.value);
    genderController = TextEditingController(
        text: controller.gender.value == 'male' ? 'ذكر' : controller.gender.value == 'female' ? 'أنثى' : controller.gender.value);
    universityNumberController = TextEditingController(text: controller.universityNumber.value);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    fatherNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    ageController.dispose();
    genderController.dispose();
    universityNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await showImagePickerDialog();
    if (image != null) {
      await controller.uploadProfilePicture(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = localStorage.isVerified();
    final role = controller.role.value;
    bool disableNameAndUniversity = (role == 'student' || role == 'overseer') && isVerified;

    return Scaffold(
      appBar: CustomAppBar(
        title: "تعديل الملف الشخصي",
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('حفظ', style: TextStyle(color: AppColors.white, fontSize: 16)),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.defaultBackgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Profile picture with edit capability
                      Obx(() => Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.all(5),
                        height: Get.width * 0.35,
                        width: Get.width * 0.35,
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 20, spreadRadius: 1)],
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: controller.profilePicture.value.isNotEmpty
                                ? NetworkImage("${controller.profilePicture.value}")
                                : AssetImage(AppConstants.defaultBackgroundImage) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              backgroundColor: AppColors.primaryAccent,
                              radius: 18,
                              child: Icon(Icons.camera_alt, size: 18, color: AppColors.white),
                            ),
                          ),
                        ),
                      )),
                      // Form fields wrapped in custom container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(80, 10),
                            bottomLeft: Radius.elliptical(10, 80),
                            topRight: Radius.elliptical(10, 80),
                            bottomRight: Radius.elliptical(80, 10),
                          ),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          boxShadow: [BoxShadow(color: AppColors.black12, blurRadius: 8)],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildField("الاسم الأول", firstNameController, enabled: !disableNameAndUniversity),
                              const SizedBox(height: 12),
                              _buildField("اسم الأب", fatherNameController, enabled: !disableNameAndUniversity),
                              const SizedBox(height: 12),
                              _buildField("الكنية", lastNameController, enabled: !disableNameAndUniversity),
                              const SizedBox(height: 12),
                              _buildField("رقم الهاتف", phoneController, keyboardType: TextInputType.phone),
                              const SizedBox(height: 12),
                              _buildField("نبذة عني", bioController, maxLines: 3),
                              if (role == 'student') ...[
                                const SizedBox(height: 12),
                                _buildField("الرقم الجامعي", universityNumberController,
                                    enabled: !disableNameAndUniversity, keyboardType: TextInputType.number),
                              ],
                              if (role == 'patient') ...[
                                const SizedBox(height: 12),
                                _buildField("العمر", ageController, keyboardType: TextInputType.number),
                                const SizedBox(height: 12),
                                _buildDropdown(),
                              ],
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {bool enabled = true, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primary700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: AppColors.primary200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: AppColors.primary, width: 2)),
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.grey.shade100,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "هذا الحقل مطلوب";
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: genderController.text.isEmpty ? null : genderController.text,
      decoration: InputDecoration(
        labelText: "الجنس",
        labelStyle: TextStyle(color: AppColors.primary700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: AppColors.primary200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: AppColors.primary, width: 2)),
        filled: true,
        fillColor: AppColors.white,
      ),
      items: const [
        DropdownMenuItem(value: 'ذكر', child: Text('ذكر')),
        DropdownMenuItem(value: 'أنثى', child: Text('أنثى')),
      ],
      onChanged: (value) {
        if (value != null) genderController.text = value;
      },
    );
  }

  Future<File?> showImagePickerDialog() async {
    // يمكنك استخدام دالة uploadPicture الموجودة لديك (bottom sheet) كما هي
    // هنا سأستخدم مثالاً مبسطاً:
    final result = await Get.dialog<File?>(
      AlertDialog(
        title: const Text("اختر مصدر الصورة"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.camera, size: 50, color: AppColors.primary),
              onPressed: () {
                // استخدام ImagePicker حقيقي
                Get.back();
              },
            ),
            IconButton(
              icon: Icon(Icons.photo_library, size: 50, color: AppColors.primary),
              onPressed: () {
                // استخدام ImagePicker حقيقي
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
    return result;
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'first_name': firstNameController.text.trim(),
        'father_name': fatherNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'bio': bioController.text.trim(),
      };
      if (controller.role.value == 'student') {
        updatedData['university_number'] = universityNumberController.text.trim();
      }
      if (controller.role.value == 'patient') {
        updatedData['age'] = ageController.text.trim();
        updatedData['gender'] = genderController.text.trim() == 'ذكر' ? 'male' : 'female';
      }
      await controller.updateProfileData(updatedData);
    }
  }
}