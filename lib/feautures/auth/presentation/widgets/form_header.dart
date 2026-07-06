import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  const FormHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
      child: Column(
        children: [
          Text(
            'إنشاء حساب جديد',
            style: TextStyles.loginHeaderStyle.copyWith(color: AppColors.onSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإنشاء حساب جديد للانضمام إلى نظام التشجير',
            style: TextStyles.footerTextTextStyle.copyWith(color: AppColors.onSecondary),
          ),
        ],
      ),
    );
  }
}