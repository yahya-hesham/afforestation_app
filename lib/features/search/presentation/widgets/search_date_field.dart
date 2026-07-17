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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black.withValues(alpha: 0.5),
                  size: 18,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: value == "dd/mm/yyyy"
                        ? Colors.grey
                        : AppColors.onSurface,
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
