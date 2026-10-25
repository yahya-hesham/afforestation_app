import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'all_plants'.tr(),
          style: TextStyles.screenHeaderTitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'browse_plants_by_type'.tr(),
          style: TextStyles.screenHeaderSubtitleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
