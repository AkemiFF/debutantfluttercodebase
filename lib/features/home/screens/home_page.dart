import 'package:flutter/material.dart';
import 'package:shoplg/features/cart/screens/cart_content.dart';
import 'package:shoplg/features/categories/screens/categories_content.dart';
import 'package:shoplg/features/home/screens/home_content.dart';
import 'package:shoplg/features/profile/screens/profile_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des pages associées aux onglets
  static final List<Widget> _pages = <Widget>[
    const HomeContent(),
    const CategoriesContent(),
    const CartContent(),
    const ProfileContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Change simplement l'index pour afficher le contenu associé
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopLG'),
      ),
      // Affiche le contenu basé sur l'index sélectionné
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
