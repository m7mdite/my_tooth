import 'package:flutter/material.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

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
            color: Colors.black54,
            spreadRadius: 5,
            blurRadius: 20,
          ),
        ],
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.blueAccent),
          right: BorderSide(color: Colors.blueAccent),
          top: BorderSide(color: Colors.blueAccent),
        ),
        borderRadius: AppThemeConstants.borderRadius
      ),
      child: child,
    );
  }
}
