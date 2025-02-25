import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:voltis_test/widgets/custom_textfield.dart';

import '../../core/router/routes.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/providers/theme_provider.dart'; // Add this import

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, Routes.profilePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode; // Add this line
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildLoginForm(),
                  SizedBox(height: 40.h,),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;  
    return Column(
      children: [
        SizedBox(height: 30.h),
        Text(
          'Login',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildLoginForm() {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
            fontSize: 14.sp
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: _emailController,
          focusNode: null, 
          labelText: 'Email',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        SizedBox(height: 15.h),
        CustomTextFormField(
          controller: _passwordController,
          focusNode: null, 
          labelText: 'Enter Password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        SizedBox(height: 8.h),
        _buildForgotPassword(),
        SizedBox(height: 30.h),
        _buildLoginButton(),
        SizedBox(height: 30.h), // Add spacing before footer
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppConstants.voltisAccent,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;  
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.voltisAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text(
        'Login',
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/sign_up');
      },
      child: Padding(
        padding: EdgeInsets.only(top: 350.h),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t Own an account? ',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.voltisAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}