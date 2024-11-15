// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:shoplg/core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCartPressed;

  const CustomAppBar({super.key, required this.onCartPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: const Text('ShopLG', style: TextStyle(color: AppColors.secondary)),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Color(0xFFFFFFFF)),
          onPressed: onCartPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
