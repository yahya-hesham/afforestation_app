import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
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
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      validator: widget.validator,
      // Pass styling options down
      decoration: _buildInputDecoration(hintText: widget.hintText),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: hintText,
      hintStyle: TextStyles.hintTextStyle.copyWith(
        color: AppColors.onSurfaceVariant.withOpacity(0.5),
        fontSize: 14,
      ),
      // 👇 This automatically styles the native error text message
      errorStyle: TextStyles.errorTextStyle.copyWith(
        color: AppColors.error,
        fontSize: 12,
      ),
      fillColor: AppColors.background,
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
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            )
          : null,

      // --- Borders Configurations ---
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.tertiary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      // 👇 Added these native error borders so you don't have to manage 'hasError' manually
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.error.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.error, width: 2.0),
      ),
    );
  }
}
