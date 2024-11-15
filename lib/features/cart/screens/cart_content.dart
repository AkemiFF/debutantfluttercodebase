import 'package:flutter/material.dart';

class CartItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String description;
  final double totalPrice;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.description,
    required this.totalPrice,
    this.imageUrl,
  });
}

class CartContent extends StatefulWidget {
  const CartContent({Key? key}) : super(key: key);

  @override
  _CartContentState createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  List<CartItem> cartItems = [];
  List<Map<String, dynamic>> recommendedProducts = [];
  bool isLoading = true;
  bool noCart = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    // Simulating API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      cartItems = [
        CartItem(
          productId: 1,
          productName: "Product 1",
          quantity: 2,
          price: 19.99,
          description: "Description 1",
          totalPrice: 39.98,
          imageUrl: "https://via.placeholder.com/100",
        ),
        CartItem(
          productId: 2,
          productName: "Product 2",
          quantity: 1,
          price: 29.99,
          description: "Description 2",
          totalPrice: 29.99,
          imageUrl: "https://via.placeholder.com/100",
        ),
      ];
      recommendedProducts = [
        {"id": 3, "name": "Recommended 1", "price": 14.99},
        {"id": 4, "name": "Recommended 2", "price": 24.99},
        {"id": 5, "name": "Recommended 3", "price": 34.99},
        {"id": 6, "name": "Recommended 4", "price": 44.99},
      ];
      isLoading = false;
      noCart = cartItems.isEmpty;
    });
  }

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double shipping = 5.99;
  double get total => subtotal + shipping;

  void handleMoreProduct(int productId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        cartItems[index] = CartItem(
          productId: cartItems[index].productId,
          productName: cartItems[index].productName,
          quantity: cartItems[index].quantity + 1,
          price: cartItems[index].price,
          description: cartItems[index].description,
          totalPrice: cartItems[index].totalPrice + cartItems[index].price,
          imageUrl: cartItems[index].imageUrl,
        );
      }
    });
  }

  void handleLessProduct(int productId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1 && cartItems[index].quantity > 1) {
        cartItems[index] = CartItem(
          productId: cartItems[index].productId,
          productName: cartItems[index].productName,
          quantity: cartItems[index].quantity - 1,
          price: cartItems[index].price,
          description: cartItems[index].description,
          totalPrice: cartItems[index].totalPrice - cartItems[index].price,
          imageUrl: cartItems[index].imageUrl,
        );
      } else if (index != -1) {
        cartItems.removeAt(index);
      }
    });
  }

  void handleRemoveItem(int productId) {
    setState(() {
      cartItems.removeWhere((item) => item.productId == productId);
      noCart = cartItems.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Votre panier', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16),
            if (noCart)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Votre panier est vide',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              )
            else
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Articles dans votre panier',
                              style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(height: 16),
                          ...cartItems
                              .map((item) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      children: [
                                        Image.network(
                                            item.imageUrl ??
                                                'assets/images/placeholder.png',
                                            width: 80,
                                            height: 80),r
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.productName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall),
                                              Text(
                                                  '${item.price.toStringAsFixed(2)} €',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () =>
                                                        handleLessProduct(
                                                            item.productId),
                                                  ),
                                                  Text(
                                                      item.quantity.toString()),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () =>
                                                        handleMoreProduct(
                                                            item.productId),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () =>
                                              handleRemoveItem(item.productId),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Résumé de la commande',
                              style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sous-total'),
                              Text('${subtotal.toStringAsFixed(2)} €'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Frais de livraison'),
                              Text('${shipping.toStringAsFixed(2)} €'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('${total.toStringAsFixed(2)} €',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Procéder au paiement'),
                            onPressed: () {
                              // Navigate to checkout page
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (!noCart) ...[
              SizedBox(height: 32),
              Text('Recommandations',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: recommendedProducts
                    .map((product) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(product['name'],
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text('${product['price'].toStringAsFixed(2)} €',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}