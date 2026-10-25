import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.validator,
    this.isPassword = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.onSurface;
    final bgColor = isDark ? const Color(0xFF2A2A2A) : AppColors.background;

    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      validator: widget.validator,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: _buildInputDecoration(
        hintText: widget.hintText,
        isDark: isDark,
        bgColor: bgColor,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required bool isDark,
    required Color bgColor,
  }) {
    return InputDecoration(
      labelText: widget.labelText,
      labelStyle: isDark ? const TextStyle(color: Colors.white70) : null,
      hintText: hintText,
      hintStyle: TextStyles.hintTextStyle.copyWith(
        color: isDark
            ? Colors.white38
            : AppColors.onSurfaceVariant.withOpacity(0.5),
        fontSize: 14,
      ),
      errorStyle: TextStyles.errorTextStyle.copyWith(
        color: AppColors.error,
        fontSize: 12,
      ),
      fillColor: bgColor,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : AppColors.tertiary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.error.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
