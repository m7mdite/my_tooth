
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constants/colors_constant.dart';

class BottomNavigationBarIcon extends StatelessWidget {
  final bool selected;
  final void Function()? onPressed;
  final IconData icon;
  final String text;
  const BottomNavigationBarIcon({
    super.key, this.selected=false, this.onPressed, required this.icon, this.text="",
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 900),
      curve: Easing.emphasizedAccelerate,
      height: 60,
      width: Get.width * 0.2,
      decoration: BoxDecoration(
        color:selected?AppColors.primaryAccent: const Color.fromARGB(180, 255, 255, 255),
        border: Border.symmetric(
          horizontal: BorderSide(
            color:selected?AppColors.white: AppColors.primary,
            width:selected?2: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                icon,
                color:selected?AppColors.white: AppColors.primary,
                size: 30,
              ),
            
            Text(text,style: TextStyle(fontSize: 8,color:selected?AppColors.white: AppColors.primary,fontWeight: FontWeight.bold ),)
          ],
        ),
      ),
    );
  }
}
