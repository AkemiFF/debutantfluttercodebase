import 'package:flutter/material.dart';
import 'package:shoplg/features/cart/screens/cart_content.dart';
import 'package:shoplg/features/categories/screens/categories_content.dart';
import 'package:shoplg/features/home/screens/home_page.dart';
import 'package:shoplg/features/profile/screens/profile_content.dart';

class AppRoutes {
  static const String home = '/';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesContent());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartContent());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileContent());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Erreur")),
            body: const Center(child: Text("Page non trouvée")),
          ),
        );
    }
  }
}
