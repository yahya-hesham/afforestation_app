import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, {bool isAdminMode = true}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return AppBar(
    backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.background,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: isDark ? Colors.white : AppColors.onSurface,
        size: 20,
      ),
      onPressed: () => Navigator.maybePop(context),
    ),
    title: Text(
      isAdminMode ? 'إضافة مستخدم جديد' : 'إنشاء حساب جديد',
      style: TextStyles.loginHeaderStyle.copyWith(
        color: isDark ? Colors.white : AppColors.onSurface,
        fontSize: 18,
      ),
    ),
    centerTitle: true,
  );
}
