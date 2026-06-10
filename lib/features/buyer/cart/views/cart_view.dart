import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../../cart/models/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.yourCart)),
      body: Obx(() {
        if (controller.isEmpty) {
          return const EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: AppStrings.cartEmpty,
            subtitle: AppStrings.cartEmptyHint,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...controller.items.map((line) => _CartTile(line: line)),
            const SizedBox(height: 16),
            _summaryRow(AppStrings.subtotal, controller.subtotal),
            _summaryRow(AppStrings.deliveryFee, controller.deliveryFee),
            const Divider(height: 24),
            _summaryRow(AppStrings.total, controller.total, bold: true),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MyButton(
              label:
                  '${AppStrings.checkout} · \$${controller.total.toStringAsFixed(2)}',
              onTap: () => Get.toNamed(AppRoutes.checkout),
            ),
          ),
        );
      }),
    );
  }

  Widget _summaryRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          MyText.body(label, weight: bold ? FontWeight.w600 : null),
          const Spacer(),
          MyText.body(
            '\$${amount.toStringAsFixed(2)}',
            weight: bold ? FontWeight.w700 : null,
            color: bold ? AppColors.primary : null,
          ),
        ],
      ),
    );
  }
}

class _CartTile extends GetView<CartController> {
  final CartItem line;

  const _CartTile({required this.line});

  @override
  Widget build(BuildContext context) {
    final item = line.product;
    final qty = line.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ProductImage(imageKey: item.imageKey, productId: item.id, height: 64, width: 64),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.subtitle(item.name),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qtyBtn(Icons.remove, () {
                      controller.updateQuantity(item.id, qty - 1);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: MyText.subtitle('$qty'),
                    ),
                    _qtyBtn(Icons.add, () {
                      controller.updateQuantity(item.id, qty + 1);
                    }),
                  ],
                ),
                const SizedBox(height: 4),
                MyText.label(
                  '\$${(item.price * qty).toStringAsFixed(2)}',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => controller.removeItem(item.id),
            child: const MyText.caption(AppStrings.remove, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
