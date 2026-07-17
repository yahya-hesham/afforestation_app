// Extracted simple AppBar method to keep build clean
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: AppColors.onSurface,
        size: 20,
      ),
      onPressed: () => Navigator.maybePop(context),
    ),
    title: Text(
      'إضافة مستخدم جديد',
      style: TextStyles.loginHeaderStyle.copyWith(color: AppColors.onSurface),
    ),
    centerTitle: true,
  );
}
