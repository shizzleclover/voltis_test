import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/routes.dart';
import '../../viewmodels/providers/theme_provider.dart';
import '../../widgets/custom_bottom_nav.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    
    return Scaffold(
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
}