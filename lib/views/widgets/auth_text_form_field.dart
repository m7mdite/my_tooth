import 'package:flutter/material.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

import '../../utils/app_constants/colors_constant.dart';

class AuthTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool isPassword;
  final Widget? suffix;
  final bool showPassword;
  final IconData? icon; 

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AuthTextFormField({
    super.key,
    required this.label,
    required this.textEditingController,
    this.isPassword = false,
    this.suffix,
    this.onChanged,
    this.validator,
    this.showPassword = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 254, 254),
          border: Border(
              right: BorderSide(
                color: AppColors.primaryAccent,
              ),
              bottom: BorderSide(
                color: AppColors.primaryAccent,
              )),
          borderRadius: AppThemeConstants.borderRadius),
      child: TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPassword,
        onChanged: onChanged,
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, size: 20, color: AppColors.primary700)
              : null,
          suffix: suffix,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: AppColors.primaryAccent,
                    ),
                    left: BorderSide(
                      color: AppColors.primaryAccent,
                    )),
                borderRadius:AppThemeConstants.borderRadius,
                color: AppColors.white,
              ),
              child: Text(
                label,
                style: TextStyle(fontSize: 15),
              )),
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
