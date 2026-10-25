import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class QuickTipCard extends StatelessWidget {
  final String tipText;

  const QuickTipCard({super.key, required this.tipText});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF56B76C).withValues(alpha: 0.12)
            : const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF56B76C).withValues(alpha: 0.25)
              : const Color(0xFFDCEDC8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "نصيحة سريعة",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tipText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.info_outline,
            color: isDark ? const Color(0xFF81C784) : AppColors.secondary,
            size: 22,
          ),
        ],
      ),
    );
  }
}
