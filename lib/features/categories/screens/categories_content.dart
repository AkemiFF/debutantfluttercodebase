import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoplg/core/utils/api_base_url.dart';
import 'package:shoplg/widgets/product_card.dart';

class CategoriesContent extends StatefulWidget {
  const CategoriesContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesContentState createState() => _CategoriesContentState();
}

class _CategoriesContentState extends State<CategoriesContent> {
  List<Map<String, dynamic>> products = [];
  List<Category> categories = [];
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(0, 1000);
  String searchTerm = '';
  String sortBy = 'featured';
  double minRating = 0;
  int currentPage = 1;
  final int productsPerPage = 24;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$apiBaseUrl/api/product/categories/'));
    if (response.statusCode == 200) {
      setState(() {
        // Décoder la réponse JSON
        final List<dynamic> responseData = json.decode(response.body);

        categories = responseData
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/api/product/'));
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> responseData = json.decode(response.body);

        products = responseData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  List<Map<String, dynamic>> get filteredAndSortedProducts {
    return products.where((product) {
      final matchesCategory = selectedCategory == 'All' ||
          product['category']['name'] == selectedCategory;
      final matchesPrice = (product['price'] as num) >= priceRange.start &&
          (product['price'] as num) <= priceRange.end;
      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
      final matchesRating = (product['average_rating'] as num) >= minRating;
      return matchesCategory && matchesPrice && matchesSearch && matchesRating;
    }).toList()
      ..sort((a, b) {
        switch (sortBy) {
          case 'price-asc':
            return (a['price'] as num).compareTo(b['price'] as num);
          case 'price-desc':
            return (b['price'] as num).compareTo(a['price'] as num);
          case 'rating':
            return (b['average_rating'] as num)
                .compareTo(a['average_rating'] as num);
          default:
            return 0;
        }
      });
  }

  List<Map<String, dynamic>> get filteredAndSortedProducts2 {
    return products.where((product) {
      final matchesCategory = selectedCategory == 'All' ||
          product['category']['name'] == selectedCategory;
      final matchesPrice =
          double.tryParse(product['price'].toString()) != null &&
              double.parse(product['price'].toString()) >= priceRange.start &&
              double.parse(product['price'].toString()) <= priceRange.end;

      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
      final matchesRating = (product['average_rating'] as num) >= minRating;
      return matchesCategory && matchesSearch && matchesRating && matchesPrice;
      // return matchesCategory && matchesPrice && matchesSearch && matchesRating;
    }).toList()
      ..sort((a, b) {
        switch (sortBy) {
          case 'price-asc':
            return (a['price'] as num).compareTo(b['price'] as num);
          case 'price-desc':
            return (b['price'] as num).compareTo(a['price'] as num);
          case 'rating':
            return (b['average_rating'] as num)
                .compareTo(a['average_rating'] as num);
          default:
            return 0;
        }
      });
  }

  List<Map<String, dynamic>> get currentProducts {
    final start = (currentPage - 1) * productsPerPage;
    final end = start + productsPerPage;
    return filteredAndSortedProducts2.sublist(
        start, end.clamp(0, filteredAndSortedProducts2.length));
  }

  void clearFilter() {
    setState(() {
      selectedCategory = 'All';
      priceRange = const RangeValues(0, 1000);
      searchTerm = '';
      minRating = 0;
    });
    fetchProducts();
  }

  void _updateProducts() {
    setState(() {
      // This empty setState will trigger a rebuild of the widget tree
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar for larger screens
          if (MediaQuery.of(context).size.width >= 600)
            SizedBox(
              width: 200,
              child: _buildFilterContent(),
            ),
          // Main content
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: currentProducts.length,
                    itemBuilder: (context, index) {
                      final product = currentProducts[index];
                      final imageUrl =
                          apiBaseUrl + product['images'][0]['image'];
                      final name = product['name'];
                      final rating = product['average_rating'];
                      final description = product['description'];
                      final reviewCount = product['review_count'];
                      final id = product['id'];
                      final price = product['price'];

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
                ),
              ],
            ),
          ),
        ],
      ),
      // Mobile filter button
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? FloatingActionButton(
              child: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildFilterContent(),
                );
              },
            )
          : null,
    );
  }

  Widget _buildFilterContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == 'All',
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = 'All';
                      _updateProducts();
                    });
                  },
                ),
                ...categories.map((category) => FilterChip(
                      label: Text(category.name),
                      selected: selectedCategory == category.name,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category.name;
                          _updateProducts();
                        });
                      },
                    )),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Price Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 1000,
              divisions: 100,
              labels: RangeLabels(
                priceRange.start.round().toString(),
                priceRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  priceRange = values;
                  _updateProducts();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Minimum Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: minRating,
              min: 0,
              max: 5,
              divisions: 5,
              label: minRating.round().toString(),
              onChanged: (double value) {
                setState(() {
                  minRating = value;
                  _updateProducts();
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Clear Filters'),
              onPressed: clearFilter,
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String frName;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.frName,
    required this.description,
  });

  // Le constructeur fromJson pour convertir le Map en un objet Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      frName: json['fr_name'],
      description: json['description'],
    );
  }
}
