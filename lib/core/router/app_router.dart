import 'package:flutter/material.dart';
import 'package:voltis_test/views/auth/sign_in_view.dart';
import '../../views/product_details/product_details.dart';
import '../../views/profile/profile_view.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Authentication Route
      case Routes.singIn:
      return MaterialPageRoute(builder: (context) => const SignInView());

      // Profile Page Route
      case Routes.profilePage:
      return MaterialPageRoute(builder: (context) => const ProfilePageView());

      //Product Details Route
      case Routes.productDetails:
      return MaterialPageRoute(builder: (context) => const ProductDetailsView());


       default:
      return MaterialPageRoute(builder: (_) => Scaffold(
        body: Center(
          child: Text('Unknown route: ${settings.name}'),
        ),

      ));
    }
    }
  }