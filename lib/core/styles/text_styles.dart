import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static final TextStyle loginHeaderStyle = GoogleFonts.inter(
    fontSize: 20.0,                
    fontWeight: FontWeight.w700, 
    color: AppColors.primary   
);

  static final TextStyle hintTextStyle = GoogleFonts.inter(
    fontSize: 20.0,               
    fontWeight: FontWeight.w400, 
    color: AppColors.primary   
  );

  static final TextStyle errorTextStyle = GoogleFonts.inter(
    fontSize: 12.0,               
    fontWeight: FontWeight.w400, 
    color: AppColors.primary   
  );

  static final TextStyle buttonTextStyle = GoogleFonts.inter(
    fontSize: 18.0,               
    fontWeight: FontWeight.w700, 
    color: AppColors.onSecondary   
  );

  static final TextStyle textButtonTextStyle = GoogleFonts.inter(
    fontSize: 14.0,               
    fontWeight: FontWeight.w500, 
    color: AppColors.onSecondary   
  );

  static final TextStyle footerTextTextStyle = GoogleFonts.inter(
    fontSize: 12.0,               
    fontWeight: FontWeight.w400, 
    color: AppColors.onSecondary   
  );

  // New styles explicitly mapped for the Plant Management Screen
  static final TextStyle appBarTitleStyle = GoogleFonts.inter(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static final TextStyle screenHeaderTitleStyle = GoogleFonts.inter(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final TextStyle screenHeaderSubtitleStyle = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static final TextStyle cardSectionTitleStyle = GoogleFonts.inter(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final TextStyle listRowTitleStyle = GoogleFonts.inter(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static final TextStyle listRowSubtitleStyle = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );
}