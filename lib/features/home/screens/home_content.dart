import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoplg/core/utils/api_base_url.dart';
import 'package:shoplg/widgets/h_product_card.dart';
import 'package:shoplg/widgets/product_card.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> featuredProducts = [];
  List<Map<String, dynamic>> deals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchCategories(),
      fetchFeaturedProducts(),
      fetchDeals(),
    ]);
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$apiBaseUrl/api/product/categories/'));
    if (response.statusCode == 200) {
      setState(() {
        categories =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  Future<void> fetchFeaturedProducts() async {
    final response =
        await http.get(Uri.parse('$apiBaseUrl/api/product/recommended/'));
    if (response.statusCode == 200) {
      setState(() {
        featuredProducts =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  Future<void> fetchDeals() async {
    final response =
        await http.get(Uri.parse('$apiBaseUrl/api/product/top-selling/'));
    if (response.statusCode == 200) {
      setState(() {
        deals = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              _buildCategories(),
              _buildFeaturedProducts(),
              _buildDealsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index]; // cat est un Map<String, dynamic>
          final name = cat['name']; // Accès à 'name' de la map
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.category, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Featured Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];

              final imageUrl = apiBaseUrl +
                  product['images'][0][
                      'image']; // Assure-toi d'utiliser `product` ici et non `deal`
              final name = product['name'];
              final price = product['price'];

              return Container(
                width: 180,
                margin: const EdgeInsets.all(8.0),
                child: HProductCard(
                  image: imageUrl,
                  name: name,
                  price: price
                      .toString(), // Convertir le prix en chaîne si nécessaire
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Deals of the Day',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: deals.length,
          itemBuilder: (context, index) {
            final deal = deals[index];

            final imageUrl = apiBaseUrl + deal['images'][0]['image'];
            final name = deal['name'];
            final rating = deal['average_rating'];
            final description = deal['description'];
            final reviewCount = deal['review_count'];
            final id = deal['id'];
            final price = deal['price'];

            return ProductCard(
              image: imageUrl,
              id: id,
              name: name,
              description: description,
              price: price.toString(),
              rating: rating,
              reviewCount: reviewCount,
              onAddToCart: () {
                print(id);
              },
            );
          },
        ),
      ],
    );
  }
}
