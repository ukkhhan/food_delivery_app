import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../cart/controllers/cart_controller.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _qty = 1;
  late final FoodItem item;
  final _cart = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    item = Get.arguments as FoodItem;
  }

  void _addToCart() {
    _cart.addItem(item, _qty);
    Get.back();
    Get.snackbar(
      AppStrings.cart,
      '${item.name} x$_qty added',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyText.title(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProductImage(productId: item.id, height: 200, radius: 16),
          const SizedBox(height: 20),
          MyText.display(item.name),
          const SizedBox(height: 6),
          MyText.label(item.category, color: AppColors.secondary),
          const SizedBox(height: 12),
          MyText.title('\$${item.price.toStringAsFixed(2)}', color: AppColors.primary),
          const SizedBox(height: 20),
          const MyText.subtitle(AppStrings.description),
          const SizedBox(height: 6),
          MyText.body(item.description, color: AppColors.textSecondary),
          const SizedBox(height: 24),
          Row(
            children: [
              const MyText.subtitle(AppStrings.quantity),
              const Spacer(),
              _qtyButton(Icons.remove, () {
                if (_qty > 1) setState(() => _qty--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyText.title('$_qty'),
              ),
              _qtyButton(Icons.add, () => setState(() => _qty++)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MyButton(
            label: '${AppStrings.addToCart} · \$${(item.price * _qty).toStringAsFixed(2)}',
            onTap: _addToCart,
          ),
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
