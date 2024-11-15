import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  List<Order> orders = [];
  Address address = Address(
      id: 0,
      name: "",
      address: "",
      city: "",
      postalCode: "",
      country: "",
      phoneNumber: "");
  List<PaymentMethod> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _fetchAddress();
    _fetchPaymentMethods();
  }

  void _fetchOrders() {
    setState(() {
      orders = [
        Order(
            id: 1,
            createdAt: DateTime.now(),
            totalPrice: 99.99,
            status: "pending",
            items: []),
        Order(
            id: 2,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            totalPrice: 149.99,
            status: "shipped",
            items: []),
      ];
    });
  }

  void _fetchAddress() {
    setState(() {
      address = Address(
          id: 1,
          name: "John Doe",
          address: "123 Main St",
          city: "Anytown",
          postalCode: "12345",
          country: "USA",
          phoneNumber: "+1 234 567 8900");
    });
  }

  void _fetchPaymentMethods() {
    setState(() {
      paymentMethods = [
        PaymentMethod(id: 1, type: "Visa", last4: "1234", expiry: "12/25"),
        PaymentMethod(
            id: 2, type: "Mastercard", last4: "5678", expiry: "06/24"),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Your Account', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Orders', _buildOrdersContent()),
            _buildSection('Addresses', _buildAddressesContent()),
            _buildSection('Payment Options', _buildPaymentsContent()),
            _buildSection('Account Settings', _buildAccountContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget _buildOrdersContent() {
    return Column(
      children: orders.map((order) => _buildOrderCard(order)).toList(),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                'Placed on ${DateFormat('MMMM d, yyyy').format(order.createdAt)}'),
            const SizedBox(height: 8),
            Text('Status: ${order.status.toUpperCase()}',
                style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Implement order details navigation
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text('View order details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesContent() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(address.address),
            Text('${address.city}, ${address.postalCode}'),
            Text(address.country),
            Text(address.phoneNumber),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement address editing
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text('Edit address'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsContent() {
    return Column(
      children: paymentMethods
          .map((method) => _buildPaymentMethodCard(method))
          .toList(),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${method.type} ending in ${method.last4}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Expires ${method.expiry}'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Implement payment method editing
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountContent() {
    return Column(
      children: [
        _buildAccountOption('Change password', Icons.lock, () {
          // Implement password change
        }),
        _buildAccountOption('Login & security', Icons.security, () {
          // Implement login & security settings
        }),
        _buildAccountOption('Your devices', Icons.devices, () {
          // Implement devices management
        }),
        _buildAccountOption('Close your account', Icons.close, () {
          // Implement account closure
        }),
      ],
    );
  }

  Widget _buildAccountOption(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class Order {
  final int id;
  final DateTime createdAt;
  final double totalPrice;
  final String status;
  final List<OrderItem> items;

  Order(
      {required this.id,
      required this.createdAt,
      required this.totalPrice,
      required this.status,
      required this.items});
}

class OrderItem {
  final int productId;
  final int quantity;
  final double price;

  OrderItem(
      {required this.productId, required this.quantity, required this.price});
}

class Address {
  final int id;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String phoneNumber;

  Address(
      {required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.postalCode,
      required this.country,
      required this.phoneNumber});
}

class PaymentMethod {
  final int id;
  final String type;
  final String last4;
  final String expiry;

  PaymentMethod(
      {required this.id,
      required this.type,
      required this.last4,
      required this.expiry});
}
