

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/tooth_constants.dart';
import '../../../models/requests_models/treatment_request_model.dart';
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
    return Dialog(
      backgroundColor: Colors.transparent,
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
                image: AssetImage(AppConstants.defaultBackgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(120, 15),
                bottomLeft: Radius.elliptical(15, 120),
                topRight: Radius.elliptical(15, 120),
                bottomRight: Radius.elliptical(120, 15),
              ),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
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
                  // شريط العنوان
                  _buildHeader(),
                  // المحتوى القابل للتمرير
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildPhotoCard(),
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
  }

  // ===================== شريط العنوان =====================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
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
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: Get.back,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              shape: const CircleBorder(),
            ),
          ),
          const Spacer(),
          Text(
            'تفاصيل الطلب',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
          const Spacer(),
          if (widget.requestModel.dateOfAccepting != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDate(widget.requestModel.dateOfAccepting!),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== بطاقة الصورة =====================
  Widget _buildPhotoCard() {
    final photo = widget.requestModel.requestion?.photo;
    final hasPhoto = photo != null && photo.url != null && photo.url!.isNotEmpty;

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
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(80, 10),
          bottomLeft: Radius.elliptical(10, 80),
          topRight: Radius.elliptical(10, 80),
          bottomRight: Radius.elliptical(80, 10),
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                  Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'لا توجد صورة',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  // ===================== بطاقات المعلومات =====================
  Widget _buildInfoCards() {
    final req = widget.requestModel.requestion;
    final more = req?.moreDetails;

    final List<Map<String, dynamic>> infoList = [
      {'icon': Icons.medical_services, 'label': 'نوع الحالة', 'value': widget.requestModel.caseType?.caseType ?? ''},
      {'icon': Icons.speed, 'label': 'شدة الألم', 'value': '${req?.painSeverity ?? 0} / 5'},
      {'icon': Icons.access_time, 'label': 'وقت الألم', 'value': req?.painTime ?? 'غير محدد'},
      {'icon': Icons.cake, 'label': 'عمر المريض', 'value': req?.age ?? 'غير محدد'},
      {'icon': Icons.person, 'label': 'جنس المريض', 'value': req?.gender ?? 'غير محدد'},
      {'icon': Icons.medical_information, 'label': 'نوع السن', 'value': ToothConstants.toothLocationMap[req?.toothLocation] ?? ''},
      if (more?.previousTreatment == true) {'icon': Icons.history, 'label': 'معالج سابقًا', 'value': 'نعم'},
      if (more?.chronicDiseases != null && more!.chronicDiseases!.isNotEmpty) {'icon': Icons.health_and_safety, 'label': 'أمراض مزمنة', 'value': more.chronicDiseases!},
      if (more?.medicines != null && more!.medicines!.isNotEmpty) {'icon': Icons.medication, 'label': 'أدوية ومكملات', 'value': more.medicines!},
      if (more?.notes != null && more!.notes!.isNotEmpty) {'icon': Icons.note, 'label': 'ملاحظة', 'value': more.notes!},
      if (widget.requestModel.courseInfo?.courseName != null) {'icon': Icons.book, 'label': 'المادة', 'value': widget.requestModel.courseInfo!.courseName!},
    ];

    return Column(
      children: infoList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildInfoCard(item['icon'], item['label'], item['value']),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 6),
          bottomLeft: Radius.elliptical(6, 40),
          topRight: Radius.elliptical(6, 40),
          bottomRight: Radius.elliptical(40, 6),
        ),
        border: Border.all(color: Colors.blueAccent.withAlpha(100), width: 1.5,strokeAlign: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              // overflow: TextOverflow.ellipsis,
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
        'color': Colors.green.shade700,
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
        'color': Colors.blue.shade700,
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
        'color': Colors.purple.shade700,
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(1, 10),
                topRight: Radius.elliptical(10, 1),
                bottomLeft: Radius.elliptical(10, 1),
                bottomRight: Radius.elliptical(1, 10),
              ),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ViewOtherProfile(profile: controller.otherProfile),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(40, 6),
            bottomLeft: Radius.elliptical(6, 40),
            topRight: Radius.elliptical(6, 40),
            bottomRight: Radius.elliptical(40, 6),
          ),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: (user['color'] as Color).withValues(alpha: 0.15),
              child: FaIcon(
                user['icon'],
                size: 18,
                color: user['color'],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              user['label'],
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                '${user['firstName']} ${user['fatherName'] ?? ''} ${user['lastName'] ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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