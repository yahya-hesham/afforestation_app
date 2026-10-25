export 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

extension Localization on BuildContext {
  bool get isArabic => locale.languageCode == 'ar';

  void toggleLanguage() {
    if (isArabic) {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ar'));
    }
  }
}
