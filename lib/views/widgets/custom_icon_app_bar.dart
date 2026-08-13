import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/public_views/conversations_screen.dart';

import '../../utils/app_constants/colors_constant.dart';

class CustomIconAppBar extends StatelessWidget {
  final void Function()? onTap;
  final bool reverseColors;
  final IconData iconData;
  const CustomIconAppBar({
    super.key,
    this.onTap,
    this.reverseColors = false,
    this.iconData = Icons.chat,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Get.to(() => ConversationsScreen());
          },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: reverseColors ? AppColors.white : AppColors.primaryLightAccent,
          
          boxShadow: [
            BoxShadow(
              color: reverseColors ? AppColors.primaryLightAccent : AppColors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), 
            ),
            BoxShadow(
              color: reverseColors ? AppColors.primaryLightAccent : AppColors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, -3), 
            ),
          ],
        ),
        child: Icon(
          iconData,
          color: reverseColors ? AppColors.primary : AppColors.white,
        ),
      ),
    );
  }
}
