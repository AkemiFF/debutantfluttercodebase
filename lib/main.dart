import 'package:flutter/material.dart';
import 'package:shoplg/features/home/screens/home_page.dart';
import 'package:shoplg/routes/routes.dart';

import 'theme/light_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const HomePage(),
    );
  }
}
