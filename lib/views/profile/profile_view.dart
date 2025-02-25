import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/router/routes.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/providers/theme_provider.dart';
import '../../widgets/custom_bottom_nav.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  TextStyle _textStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    bool isDarkMode = false,
  }) {
    // If a specific color is provided, use it, otherwise use theme-based color
    final defaultColor = isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark;
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color ?? defaultColor,  // Use provided color or default theme color
    );
  }

  void _showQuestionModal(BuildContext context, bool isDarkMode) {
    final TextEditingController questionController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppConstants.voltisDark : AppConstants.voltisLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ask a Question',
              style: _textStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: questionController,
              maxLines: 3,
              style: _textStyle(
                fontSize: 14,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
              ),
              decoration: InputDecoration(
                hintText: 'Type your question here...',
                hintStyle: _textStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppConstants.borderDark : AppConstants.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppConstants.borderDark : AppConstants.borderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: AppConstants.voltisAccent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.voltisAccent,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  // Here you would handle sending the question
                  Navigator.pop(context);
                },
                child: Text(
                  'Send Question',
                  style: _textStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Column(
        children: [
          // Cover Image Section
          Container(
            width: screenWidth,
            height: 450.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/core/Images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(   
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          'Asos Edited patchwork quilt jacket in red and cherry',
                          style: _textStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                           color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Asos Originals',
                              style: _textStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.filterColor,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Text(
                              'Size S',
                              style: _textStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.filterColor,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'New with tags',
                          style: _textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? AppConstants.txtColor : AppConstants.voltisDark,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          '£300.00',
                          style: _textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                           color: isDarkMode ? AppConstants.txtColor : AppConstants.voltisDark,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '£310.70 including Buyer Protection',
                          style: _textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.filterColor,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        // User Profile Section
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundImage: const AssetImage('lib/core/Images/avatar.png'),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selena204',
                                  style: _textStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    ...List.generate(5, (index) => 
                                      Icon(
                                        Icons.star, 
                                        color: const Color.fromRGBO(255, 215, 0, 1),
                                        size: 16.sp,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '(250)',
                                      style: _textStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                                        fontWeight: FontWeight.w500,
                                        isDarkMode: isDarkMode,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              
                            ),
                            SizedBox(width: 30.w,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Remove background color
                                elevation: 0, // Remove shadow
                                side: BorderSide( // Add white border
                                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () => _showQuestionModal(context, isDarkMode), 
                              child: Center(
                                child: Text(
                                  'Ask a Question',
                                  style: _textStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                   color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(  
                    thickness: 5.h,
                    height: 5.h,
                    color: AppConstants.dividerColor,
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(  // Changed to Column to stack texts vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: _textStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? AppConstants.dividerColor : AppConstants.voltisDark,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 8.h),  
                        Text(
                          'Item has never been worn, it was initially bought as a gift for my sister but it didn\'t fit.',
                          style: _textStyle(
                            fontSize: 14,
                          color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(  
                    thickness: 2.h,
                    height: 2.h,
                    color: AppConstants.dividerColor,
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoRow('Category', 'Jackets', isDarkMode: isDarkMode),
                  _buildDividerThin(),
                  _buildInfoRow('Brand', 'Asos', isDarkMode: isDarkMode),
                  _buildDividerThin(),
                  _buildInfoRow('Size', 'S', isDarkMode: isDarkMode),
                  _buildDividerThin(),
                  _buildInfoRow('Condition', 'New with Tags', isDarkMode: isDarkMode),
                  _buildDividerThin(),
                  _buildInfoRow('Views', '240', isDarkMode: isDarkMode),
                  _buildDividerThin(),
                  _buildInfoRow('Uploaded', '1 week ago', isDarkMode: isDarkMode),
                  SizedBox(height: 15.h),
                  // Add thick divider
                  Divider(  
                    thickness: 5.h,
                    height: 5.h,
                    color: AppConstants.dividerColor,
                  ),
                  SizedBox(height: 15.h),
                  // Add Postage section
                  _buildInfoRow('Postage', 'From £1.99', isDarkMode: isDarkMode),
                  SizedBox(height: 15.h),
                  // Add another thick divider
                  Divider(  
                    thickness: 5.h,
                    height: 5.h,
                    color: AppConstants.dividerColor,
                  ),
                  SizedBox(height: 15.h),
                  // Add More from seller section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'More from seller',
                          style: _textStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                         color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                          ),
                        ),
                        Text(
                          'Similar Items',
                          style: _textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.voltisAccent,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        isDarkMode: isDarkMode,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, Routes.productDetails);
          }
        },
      ),
    );
  }

  Widget _buildDividerThin() {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Divider(  
          thickness: 2.h,
          height: 2.h,
          color: AppConstants.dividerColor,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isDarkMode = false}) {  // Add isDarkMode parameter
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: _textStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              isDarkMode: isDarkMode,  // Pass isDarkMode
            ),
          ),
          Text(
            value,
            style: _textStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              isDarkMode: isDarkMode,  // Pass isDarkMode
            ),
          ),
        ],
      ),
    );
  }
}