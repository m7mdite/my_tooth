import 'package:flutter/material.dart';

import 'colors_constant.dart';

class AppGradients {
  static LinearGradient get arcticFrostGradient => LinearGradient(
        // ✅ get بدل =
        colors: [
          AppColors.white, // ✅ بدل white
          AppColors.white70, // ✅ بدل white70
          AppColors.primaryLightAccent, // ✅
          AppColors.primary, // ✅ يتغير حسب الثيم

          // AppColors.background,
          // AppColors.primary,
          // AppColors.primaryLightAccent,
          // AppColors.primaryAccent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
