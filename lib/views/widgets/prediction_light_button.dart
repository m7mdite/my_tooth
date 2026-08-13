import 'package:flutter/material.dart';

/// زر دائري "مضيء" (بستايل ضوء/lightbulb) لتشغيل أي عملية تنبؤ اختيارية.
/// قابل لإعادة الاستخدام: التنبؤ بإمكانية العلاج (كهرماني/lightbulb
/// افتراضياً) أو التنبؤ بنوع المعالجة (بلون وأيقونة مختلفين مثلاً).
class PredictionLightButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String label;
  final Color color;
  final IconData icon;

  const PredictionLightButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.label = 'تحقق مبدئي',
    this.color = Colors.amber,
    this.icon = Icons.lightbulb,
  });

  @override
  Widget build(BuildContext context) {
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
              color: color.withValues(alpha: isLoading ? 0.08 : 0.15),
              border: Border.all(color: color, width: 2),
              boxShadow: isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: color.withValues(alpha: 0.55),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: color,
                      ),
                    )
                  : Icon(
                      icon,
                      color: color,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLoading ? 'جاري التحقق...' : label,
            textAlign: TextAlign.center,
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
