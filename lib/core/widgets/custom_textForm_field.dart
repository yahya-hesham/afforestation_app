import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator; // Fixed type definition

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
    // Initialize state based on whether it is a password field
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      validator: widget.validator,
      decoration: _buildInputDecoration(hintText: widget.hintText),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    bool hasError = false,
  }) {
    return InputDecoration(
      labelText: widget.labelText, // Integrated your label text configuration
      hintText: hintText,
      hintStyle: TextStyles.hintTextStyle.copyWith(
        color: AppColors.onSurfaceVariant.withOpacity(0.5), 
        fontSize: 14,
      ),
      fillColor: AppColors.background,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // Conditionally show toggle button only if widget is a password field
      suffixIcon: widget.isPassword 
          ? IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: hasError ? AppColors.error.withOpacity(0.5) : AppColors.tertiary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: hasError ? AppColors.error : AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }
}
