import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class SearchDateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const SearchDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF2C2C2C) : AppColors.background;
    final labelColor = isDark ? Colors.white : AppColors.onSurface;
    final iconColor = isDark ? Colors.white60 : Colors.black.withValues(alpha: 0.5);
    final borderColor = isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08);

    Color textColor;
    if (value == "dd/mm/yyyy") {
      textColor = isDark ? Colors.white38 : Colors.grey;
    } else {
      textColor = isDark ? Colors.white : AppColors.onSurface;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: iconColor,
                  size: 18,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
