import 'package:flutter/material.dart';
import 'package:shoplg/features/home/screens/home_page.dart';
import 'package:shoplg/routes/routes.dart';

import 'theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLG',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
