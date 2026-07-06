// Helper Widget for Row Labels (Text + Icon side by side)

import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BuiledFieldLabel extends StatelessWidget {
  const BuiledFieldLabel({
    super.key,
    required this.labelText,
    required this.icon,
  });

  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 20),
        Text(
          labelText,
          style: TextStyles.loginHeaderStyle.copyWith(
            fontSize: 14,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
