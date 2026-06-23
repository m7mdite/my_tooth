import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/public_views/notifications_view.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';

import '../../services/local_storge/local_user_storage.dart';
import '../../utils/app_constants/app_theme.dart'; // تأكد من المسار

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool notifacation;
  final VoidCallback? onLeadingPressed;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;
  final Color? titleColor;
  final bool centerTitle;
  final double? elevation;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showVerifiedBadge;
  final double titleSize;
  final List<BoxShadow>? titleShadows;
  final bool useLargeTitle; // تأثير العنوان الكبير (كما في iOS)

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onLeadingPressed,
    this.backgroundColor,
    this.backgroundGradient,
    this.titleColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.leading,
    this.titleWidget,
    this.showVerifiedBadge = false,
    this.titleSize = 20,
    this.titleShadows,
    this.useLargeTitle = false,
    this.notifacation = false,
  });

  @override
  Widget build(BuildContext context) {
    final localStorage = Get.find<LocalUserStorage>();
    final bool isStudent = localStorage.getRole() == 'student';
    final bool isVerified = localStorage.isVerified();

    // اختيار التدرج المناسب (يمكن تمريره من الخارج أو اختياره ديناميكياً حسب الدور)
    final effectiveGradient =
        backgroundGradient ?? AppGradients.arcticFrostGradient;

    return AppBar(
      titleTextStyle: TextStyle(
        color: titleColor ?? Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: titleSize,
        shadows: titleShadows ??
            [
              const BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                // offset: Offset(0, 2),
              ),
            ],
      ),
      title: useLargeTitle
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: titleWidget ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: titleColor ?? Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                            shadows: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showVerifiedBadge && isStudent && isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            color: Colors.white, size: 22),
                      ],
                    ],
                  ),
            )
          : (titleWidget ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                      shadows: titleShadows,
                    ),
                  ),
                  if (showVerifiedBadge && isStudent && isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Colors.white, size: 18),
                  ],
                ],
              )),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      flexibleSpace: (backgroundColor == null)
          ? Container(
              decoration: BoxDecoration(
                gradient: effectiveGradient,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            )
          : null,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (automaticallyImplyLeading
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: onLeadingPressed ?? () => Get.back(),
                  ),
                )
              : null),
      actions: notifacation && actions == null
          ? _defaultActions(context, isStudent, isVerified)
          : actions,
      // actions: actions ==null && notifacation  ? _defaultActions(context, isStudent, isVerified),
      // تأثير شفافية للخلفية عند التمرير (اختياري)
      scrolledUnderElevation: 0,
    );
  }

  List<Widget> _defaultActions(
      BuildContext context, bool isStudent, bool isVerified) {
    return [
      CustomIconAppBar(
        iconData: Icons.notifications_none_outlined,
        onTap: () {
          () => Get.to(() => const NotificationsView());
        },
      ),
      if (isStudent && !isVerified)
        IconButton(
          icon: const Icon(Icons.verified_user_outlined, color: Colors.white),
          onPressed: () => Get.toNamed('/viewVerify'),
        ),
    ];
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(useLargeTitle ? kToolbarHeight + 20 : kToolbarHeight);
}
