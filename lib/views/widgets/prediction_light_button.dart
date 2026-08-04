import 'package:flutter/material.dart';

/// زر دائري "مضيء" (بستايل ضوء/lightbulb) لتشغيل التنبؤ بإمكانية العلاج.
/// اختياري بالكامل — المريض حر يستخدمه أو يتجاهله.
class PredictionLightButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String label;

  const PredictionLightButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.label = 'تحقق مبدئي',
  });

  @override
  Widget build(BuildContext context) {
    const glowColor = Colors.amber;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glowColor.withOpacity(isLoading ? 0.08 : 0.15),
              border: Border.all(color: glowColor, width: 2),
              boxShadow: isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: glowColor.withOpacity(0.55),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: glowColor,
                      ),
                    )
                  : const Icon(
                      Icons.lightbulb,
                      color: glowColor,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLoading ? 'جاري التحقق...' : label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
