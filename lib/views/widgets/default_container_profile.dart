import 'package:flutter/material.dart';

import '../../utils/app_constants/colors_constant.dart';

class DefaultContainerProfile extends StatelessWidget {
  final String title;
  final Color? color;
  final IconData? icon;
  final void Function()? onTap;
  const DefaultContainerProfile({super.key,this.title="ولا شي", this.color, this.icon=Icons.delete_forever, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50, ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(color: color!, blurRadius: 20, spreadRadius: 1)
          ],
          border: Border.all(
            width: 2,
            color: AppColors.white,
            strokeAlign: 7,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
              ),
            ),
            Icon(
              icon,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
