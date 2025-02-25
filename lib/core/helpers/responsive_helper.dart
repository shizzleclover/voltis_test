import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static double get ratio => ScreenUtil().pixelRatio ?? 1;
  static bool get isTablet => ratio > 2;
  static bool get isMobile => !isTablet;
  
  static double get gridAspectRatio => isTablet ? 0.75 : 0.58;
  static double get imageAspectRatio => isTablet ? 1.2 : 1.0;
  
  static EdgeInsets get standardPadding => EdgeInsets.all(16.w);
  static EdgeInsets get smallPadding => EdgeInsets.all(8.w);
  
  static double adaptiveRadius(double value) => value.r;
  static double adaptiveHeight(double value) => value.h;
  static double adaptiveWidth(double value) => value.w;
}
