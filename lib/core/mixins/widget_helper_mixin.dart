import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/ui_constants.dart';

mixin WidgetHelperMixin {
  Widget addVerticalSpace([double? height]) => SizedBox(
    height: height?.h ?? UIConstants.standardSpacing,
  );

  Widget addHorizontalSpace([double? width]) => SizedBox(
    width: width?.w ?? UIConstants.standardPadding,
  );

  EdgeInsets get standardPadding => EdgeInsets.all(UIConstants.standardPadding);

  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: UIConstants.standardPadding,
  );
}
