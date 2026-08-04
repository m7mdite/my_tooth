import 'package:flutter/material.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

import '../../utils/app_constants/colors_constant.dart';

class ContainerProfileItems extends StatelessWidget {
  final Widget? child;
  const ContainerProfileItems({
    super.key, this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black54,
            spreadRadius: 5,
            blurRadius: 20,
          ),
        ],
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.primaryAccent),
          right: BorderSide(color: AppColors.primaryAccent),
          top: BorderSide(color: AppColors.primaryAccent),
        ),
        borderRadius: AppThemeConstants.borderRadius
      ),
      child: child,
    );
  }
}
