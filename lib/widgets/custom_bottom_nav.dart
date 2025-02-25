import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isDarkMode;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppConstants.voltisDark : AppConstants.voltisLight,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? AppConstants.dividerColor : AppConstants.borderLight,
            width: 1.h,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: CupertinoIcons.square_grid_2x2,
            label: 'Products',
            isSelected: selectedIndex == 0,
          ),
          _buildNavItem(
            icon: CupertinoIcons.person,
            label: 'Profile',
            isSelected: selectedIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onItemSelected(label == 'Products' ? 0 : 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected 
                ? AppConstants.voltisAccent
                : isDarkMode 
                    ? AppConstants.voltisLight 
                    : AppConstants.voltisDark,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: isSelected 
                  ? AppConstants.voltisAccent
                  : isDarkMode 
                      ? AppConstants.voltisLight 
                      : AppConstants.voltisDark,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
