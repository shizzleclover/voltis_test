import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voltis_test/core/router/app_router.dart';
import 'package:voltis_test/core/router/routes.dart';
import 'package:provider/provider.dart';
import 'viewmodels/providers/product_details_provider.dart';
import 'viewmodels/providers/theme_provider.dart';
import 'viewmodels/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailsProvider()), // Add this line
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Voltis Test',
          theme: context.watch<ThemeProvider>().currentTheme,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.productDetails,
        );
      },
    );
  }
}