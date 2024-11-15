import 'package:flutter/material.dart';
import 'package:shoplg/features/cart/screens/cart_content.dart';
import 'package:shoplg/features/categories/screens/categories_content.dart';
import 'package:shoplg/features/home/screens/home_content.dart';
import 'package:shoplg/features/profile/screens/profile_content.dart';
import 'package:shoplg/widgets/custom_app_bar.dart';
import 'package:shoplg/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeContent(),
    const CategoriesContent(),
    const CartContent(),
    const ProfileContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onCartPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
