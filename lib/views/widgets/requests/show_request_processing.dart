import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/requests_models/treatment_request_model.dart';
import '../../../utils/app_constants/app_images_constant.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../public_views/view_other_profile.dart';

class ShowRequestProcessing extends StatefulWidget {
  final TreatmentRequestModel requestModel;
  final List<Widget> children;

  const ShowRequestProcessing({
    super.key,
    required this.requestModel,
    this.children = const <Widget>[],
  });

  @override
  State<ShowRequestProcessing> createState() => _ShowRequestProcessingState();
}

class _ShowRequestProcessingState extends State<ShowRequestProcessing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.92,
                  maxWidth: Get.width * 0.95,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.authBackground),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.linearToSrgbGamma(),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(120, 15),
                    bottomLeft: Radius.elliptical(15, 120),
                    topRight: Radius.elliptical(15, 120),
                    bottomRight: Radius.elliptical(120, 15),
                  ),
                  border: Border.all(color: AppColors.primary, width: 2.5), // ✅
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(120, 15),
                    bottomLeft: Radius.elliptical(15, 120),
                    topRight: Radius.elliptical(15, 120),
                    bottomRight: Radius.elliptical(120, 15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              _buildPhotoCard(),
                              const SizedBox(height: 12),

                              // ✅ قسم ملخص الحالة المكتملة (جديد)
                              if (widget.requestModel.status == 'finished')
                                _buildFinishedSummaryCard(),

                              const SizedBox(height: 12),
                              _buildInfoCards(),
                              const SizedBox(height: 12),
                              _buildProfileCards(),
                              const SizedBox(height: 8),
                              ...widget.children,
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===================== شريط العنوان =====================
  Widget _buildHeader() {
    final isFinished = widget.requestModel.status == 'finished';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFinished
              ? [AppColors.success.shade700, AppColors.success] // ✅ أخضر للمكتملة
              : [AppColors.primary800, AppColors.primary500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(120, 15),
          topRight: Radius.elliptical(15, 120),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.white),
            onPressed: Get.back,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.background.withOpacity(0.3),
              shape: const CircleBorder(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isFinished) ...[
                const Icon(Icons.check_circle, color: AppColors.white, size: 18),
                const SizedBox(width: 6),
              ],
              Text(
                isFinished ? 'حالة مكتملة' : 'تفاصيل الطلب',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (widget.requestModel.dateOfAccepting != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDate(widget.requestModel.dateOfAccepting!),
                style:
                    const TextStyle(color: AppColors.white, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== ✅ قسم ملخص الحالة المكتملة (جديد) =====================
  Widget _buildFinishedSummaryCard() {
    final rating = widget.requestModel.rating;
    final feedback = widget.requestModel.feedback;
    final courseName = widget.requestModel.courseInfo?.courseName ??
        widget.requestModel.courseInfoAlt?.courseName;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        border: Border.all(
          color: AppColors.success.withOpacity(0.4),
          width: 1.5,
          strokeAlign: 3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Icon(Icons.task_alt, color: AppColors.success, size: 18),
              const SizedBox(width: 8),
              Text(
                'ملخص الحالة المكتملة',
                style: TextStyle(
                  color: AppColors.success.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // المادة (للمريض)
          if (courseName != null) ...[
            _summaryRow(
              icon: Icons.book_outlined,
              label: 'المادة',
              value: courseName,
              valueColor: AppColors.primary,
            ),
            const SizedBox(height: 6),
          ],

          // التقييم بنجوم
          if (rating != null) ...[
            Row(
              children: [
                Icon(Icons.star_rate_outlined,
                    color: AppColors.warning, size: 16),
                const SizedBox(width: 8),
                Text(
                  'التقييم',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  '$rating/5',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // التعليق / الفيدباك
          if (feedback != null && feedback.isNotEmpty) ...[
            _summaryRow(
              icon: Icons.comment_outlined,
              label: 'التعليق',
              value: feedback,
              valueColor: AppColors.textPrimary,
            ),
          ],
        ],
      ),
    );
  }

  // صف معلومة واحدة داخل الملخص
  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style:
              TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  // ===================== بطاقة الصورة =====================
  Widget _buildPhotoCard() {
    final photo = widget.requestModel.requestion?.photo;
    final hasPhoto =
        photo != null && photo.url != null && photo.url!.isNotEmpty;

    return Container(
      height: hasPhoto ? Get.width * 0.6 : 80,
      width: hasPhoto ? Get.width * 0.85 : double.infinity,
      decoration: BoxDecoration(
        image: hasPhoto
            ? DecorationImage(
                image: NetworkImage("${photo!.url!}"),
                fit: BoxFit.cover,
              )
            : null,
        color: hasPhoto ? null : AppColors.cardColor, // ✅
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(80, 10),
          bottomLeft: Radius.elliptical(10, 80),
          topRight: Radius.elliptical(10, 80),
          bottomRight: Radius.elliptical(80, 10),
        ),
        border: Border.all(color: AppColors.borderColor, width: 1.5), // ✅
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: hasPhoto
          ? null
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined,
                      size: 40, color: AppColors.grey400),
                  const SizedBox(height: 4),
                  Text(
                    'لا توجد صورة',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  // ===================== بطاقات المعلومات =====================
  Widget _buildInfoCards() {
    final req = widget.requestModel.requestion;

    final List<Map<String, dynamic>> infoList = [
      {
        'icon': Icons.medical_services,
        'label': 'نوع الحالة',
        'value': widget.requestModel.caseType?.caseType ?? ''
      },
      {
        'icon': Icons.speed,
        'label': 'شدة الألم',
        'value': '${req?.painSeverity ?? 0} / 5'
      },
      {
        'icon': Icons.access_time,
        'label': 'وقت الألم',
        'value': req?.painTime ?? 'غير محدد'
      },
      {
        'icon': Icons.cake,
        'label': 'عمر المريض',
        'value': req?.age ?? 'غير محدد'
      },
      {
        'icon': Icons.person,
        'label': 'جنس المريض',
        'value': req?.gender ?? 'غير محدد'
      },
      {
        'icon': Icons.medical_information,
        'label': 'نوع السن',
        'value':
            ToothConstants.toothLocationMap[req?.toothLocation] ?? ''
      },
      if (req!.previousTreatment == true)
        {'icon': Icons.history, 'label': 'معالج سابقًا', 'value': 'نعم'},
      if (req.chronicDiseases != null && req.chronicDiseases!.isNotEmpty)
        {
          'icon': Icons.health_and_safety,
          'label': 'أمراض مزمنة',
          'value': req.chronicDiseases!
        },
      if (req.medicines != null && req.medicines!.isNotEmpty)
        {
          'icon': Icons.medication,
          'label': 'أدوية ومكملات',
          'value': req.medicines!
        },
      if (req.notes != null && req.notes!.isNotEmpty)
        {'icon': Icons.note, 'label': 'ملاحظة', 'value': req.notes!},
    ];

    return Column(
      children: infoList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child:
              _buildInfoCard(item['icon'], item['label'], item['value']),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withValues(alpha: 0.9), // ✅ بدل white
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        border: Border.all(
          color: AppColors.primary.withAlpha(100),
          width: 1.5,
          strokeAlign: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary700),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 13), // ✅
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary, // ✅ بدل black87
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== بطاقات الملفات الشخصية =====================
  Widget _buildProfileCards() {
    final users = <Map<String, dynamic>>[];

    if (widget.requestModel.overseer != null) {
      users.add({
        'id': widget.requestModel.overseer!.user,
        'firstName': widget.requestModel.overseer!.firstName,
        'fatherName': widget.requestModel.overseer!.fatherName,
        'lastName': widget.requestModel.overseer!.lastName,
        'icon': FontAwesomeIcons.userDoctor,
        'label': 'المشرف',
        'color': AppColors.success.shade700,
      });
    }

    if (widget.requestModel.patient != null) {
      users.add({
        'id': widget.requestModel.patient!.user,
        'firstName': widget.requestModel.patient!.firstName,
        'fatherName': widget.requestModel.patient!.fatherName,
        'lastName': widget.requestModel.patient!.lastName,
        'icon': FontAwesomeIcons.user,
        'label': 'المريض',
        'color': AppColors.primary700,
      });
    }

    if (widget.requestModel.student != null) {
      users.add({
        'id': widget.requestModel.student!.user,
        'firstName': widget.requestModel.student!.firstName,
        'fatherName': widget.requestModel.student!.fatherName,
        'lastName': widget.requestModel.student!.lastName,
        'icon': FontAwesomeIcons.userGraduate,
        'label': 'الطالب',
        'color': AppColors.purple.shade700,
      });
    }

    if (users.isEmpty) return const SizedBox.shrink();

    return Column(
      children: users.map((user) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildProfileCard(user),
        );
      }).toList(),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> user) {
    return InkWell(
      onTap: () async {
        final controller = Get.find<PublicController>();
        await controller.getOtherProfile(user['id']);
        Get.dialog(
          Container(
            padding: const EdgeInsets.all(6),
            margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.1,
              vertical: Get.height * 0.1,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface, // ✅
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(1, 10),
                topRight: Radius.elliptical(10, 1),
                bottomLeft: Radius.elliptical(10, 1),
                bottomRight: Radius.elliptical(1, 10),
              ),
              border:
                  Border.all(color: AppColors.borderColor, width: 1.5), // ✅
            ),
            child: ViewOtherProfile(profile: controller.otherProfile),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.9), // ✅
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(40, 6),
            bottomLeft: Radius.elliptical(6, 40),
            topRight: Radius.elliptical(6, 40),
            bottomRight: Radius.elliptical(40, 6),
          ),
          border: Border.all(color: AppColors.borderColor, width: 1.5), // ✅
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  (user['color'] as Color).withValues(alpha: 0.15),
              child: FaIcon(user['icon'], size: 18, color: user['color']),
            ),
            const SizedBox(width: 12),
            Text(
              user['label'],
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13), // ✅
            ),
            const Spacer(),
            Flexible(
              child: Text(
                '${user['firstName']} ${user['fatherName'] ?? ''} ${user['lastName'] ?? ''}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary, // ✅
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== دوال مساعدة =====================
  String _formatDate(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateTimeStr.substring(0, 10);
    }
  }
}
