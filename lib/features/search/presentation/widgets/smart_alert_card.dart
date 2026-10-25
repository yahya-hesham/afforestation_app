import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class SmartAlertCard extends StatelessWidget {
  final String title;
  final String message;

  const SmartAlertCard({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF7FBF7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.secondary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(
                alpha: isDark ? 0.25 : 0.15,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_outlined,
              color: isDark ? const Color(0xFF81C784) : AppColors.primary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
