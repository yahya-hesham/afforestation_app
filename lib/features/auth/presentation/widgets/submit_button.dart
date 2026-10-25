import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BuildSubmitButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? buttonText;

  const BuildSubmitButton({super.key, this.onTap, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.person_add_alt_1_outlined, size: 22),
        label: Text(
          buttonText ?? 'btn_register'.tr(),
          style: TextStyles.buttonTextStyle.copyWith(
            color: AppColors.onSecondary,
          ),
        ),
      ),
    );
  }
}
