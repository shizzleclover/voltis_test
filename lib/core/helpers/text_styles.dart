import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class AppTextStyles {
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get accent => body.copyWith(
    color: AppConstants.voltisAccent,
    fontWeight: FontWeight.w500,
  );
}
