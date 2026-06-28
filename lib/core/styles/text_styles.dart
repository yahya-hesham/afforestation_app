import 'package:bookia/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
abstract class TextStyles {


 // Your exact styling from the CSS panel: Inter, 20px, Bold (700)

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

}

