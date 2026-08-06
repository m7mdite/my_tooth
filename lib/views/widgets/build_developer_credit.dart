import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constants/colors_constant.dart';

Widget buildDeveloperCredit() {
  return Center(
    child: GestureDetector(
      onTap: () => _showDevCard(),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:BorderRadius.only(
                      topLeft: Radius.elliptical(100, 10),
                      bottomLeft: Radius.elliptical(10, 100),
                      topRight: Radius.elliptical(10, 100),
                      bottomRight: Radius.elliptical(100, 10),
                    ),
          border: Border.all(color: AppColors.borderColor, width: 1.5,strokeAlign: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(Icons.code_rounded,
                  size: 13, color: AppColors.white),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('أبو مصعب',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  Text('مطوّر التطبيق',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showDevCard() {
  
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.surface,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // خط علوي
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryAccent],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.terminal_rounded,
                          color: AppColors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'محمد صادق عوض',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '@m7mdite',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: AppColors.borderColor),
                const SizedBox(height: 14),
                _devRow(Icons.phone_outlined, '0957863599'),
                _devRow(Icons.telegram, 't.me/m7mdite'),
                _devRow(Icons.code, 'github.com/m7mdite'),
                _devRow(Icons.phone_android_rounded,
                    'مطوّر Flutter · خبرة عدة سنوات'),
                const SizedBox(height: 12),
                Center(
                  child: Text('© 2026 — جميع الحقوق محفوظة',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _devRow(IconData icon, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary)),
      ],
    ),
  );
}
