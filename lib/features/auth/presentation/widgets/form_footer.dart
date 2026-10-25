import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FormFooter extends StatelessWidget {
  const FormFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white60 : AppColors.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 24.0, right: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'بالتسجيل، أنت توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا',
            style: TextStyles.footerTextTextStyle.copyWith(
              color: textColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'AfforestationPanel.',
            style: TextStyles.footerTextTextStyle.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
