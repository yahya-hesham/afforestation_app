import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('كافة النباتات', style: TextStyles.screenHeaderTitleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text('تصفح وإدارة النباتات حسب النوع', style: TextStyles.screenHeaderSubtitleStyle, textAlign: TextAlign.center),
      ],
    );
  }
}