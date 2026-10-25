import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const FormHeader({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
      child: Column(
        children: [
          Text(
            title ?? 'register_header'.tr(),
            style: TextStyles.loginHeaderStyle.copyWith(
              color: AppColors.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle ?? 'register_subtitle'.tr(),
            style: TextStyles.footerTextTextStyle.copyWith(
              color: AppColors.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
