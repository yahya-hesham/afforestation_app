import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppColors {
  static const Color primary = Color(
    0xFF2D5A27,
  ); // limeGreen: Form buttons, active navigation, active filter pill
  static const Color onPrimary = Color(
    0xFFFFFFFF,
  ); // Pure White: Bold text/icons resting over primary green

  static const Color secondary = Color(
    0xFF74C365,
  ); // secondary-500: Notification block backgrounds, FAB buttons, major headers
  static const Color onSecondary = Color(
    0xFFFFFFFF,
  ); // Pure White: Text or badges resting on top of secondary green

  static const Color tertiary = Color(
    0xFF4B684B,
  ); // darkGreen: Subtle borders, input wrappers, grouping dividers
  static const Color onTertiary = Color(0xFFFFFFFF);

  // =========================================================================
  // Canvas Layers (Background vs Containers)
  // =========================================================================
  static const Color background = Color(
    0xFFF9FBF9,
  ); // paleWhite: App body scaffold background (soft greenish-white tint)
  static const Color onBackground = Color(
    0xFF131B13,
  ); // black: High-contrast body labels on the canvas layer

  static const Color surface = Color(
    0xFFFFFFFF,
  ); // Pure White: Text input fields, white user rows, list tiles, and card boundaries

  // =========================================================================
  // Typography Color Roles (Text System)
  // =========================================================================
  static const Color onSurface = Color(
    0xFF131B13,
  ); // black: High-emphasis typography (Bold screen names, main user titles)
  static const Color onSurfaceVariant = Color(
    0xFF4B684B,
  ); // darkGreen: Medium-emphasis text (Emails, subtitles, inactive text labels)

  // =========================================================================
  // Destructive States & Flags
  // =========================================================================
  static const Color error = Color(
    0xFFE74C3C,
  ); // darkRed: Trash bin icons, validation flags, delete actions
  static const Color onError = Color(0xFFFFFFFF);
}
