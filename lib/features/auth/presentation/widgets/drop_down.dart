import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class RoleDropdownField extends StatelessWidget {
  final String selectedRole;
  final List<String> roles;
  final ValueChanged<String?> onChanged;

  const RoleDropdownField({
    super.key,
    required this.selectedRole,
    required this.roles,
    required this.onChanged,
  });

  String _formatRole(String role) {
    if (role.contains('Admin') || role.contains('مسؤول')) {
      return 'مستخدم مسؤول (Admin)';
    }
    return 'مستخدم عادي (User)';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF2A2A2A) : AppColors.background;
    final textColor = isDark ? Colors.white : AppColors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.tertiary.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          dropdownColor: bgColor,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: textColor),
          items: roles.map((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                _formatRole(role),
                style: TextStyles.hintTextStyle.copyWith(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

