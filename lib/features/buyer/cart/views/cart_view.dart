import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/food_image_box.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final lines = [
      (MockData.foods[0], 2),
      (MockData.foods[2], 1),
    ];

    if (lines.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const MyText.title(AppStrings.yourCart)),
        body: const EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: AppStrings.cartEmpty,
          subtitle: AppStrings.cartEmptyHint,
        ),
      );
    }

    final subtotal = lines.fold<double>(
      0,
      (sum, e) => sum + e.$1.price * e.$2,
    );
    const delivery = 2.99;
    final total = subtotal + delivery;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.yourCart)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...lines.map((e) => _CartTile(item: e.$1, qty: e.$2)),
          const SizedBox(height: 16),
          _summaryRow(AppStrings.subtotal, subtotal),
          _summaryRow(AppStrings.deliveryFee, delivery),
          const Divider(height: 24),
          _summaryRow(AppStrings.total, total, bold: true),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MyButton(
            label: '${AppStrings.checkout} · \$${total.toStringAsFixed(2)}',
            onTap: () => Get.toNamed(AppRoutes.checkout),
          ),
        ),
      ),
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

class _CartTile extends StatelessWidget {
  final FoodItem item;
  final int qty;

  const _CartTile({required this.item, required this.qty});

  @override
  Widget build(BuildContext context) {
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
          FoodImageBox(emoji: item.emoji, height: 64, width: 64),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.subtitle(item.name),
                const SizedBox(height: 4),
                MyText.caption('x$qty'),
                const SizedBox(height: 4),
                MyText.label(
                  '\$${(item.price * qty).toStringAsFixed(2)}',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const MyText.caption(AppStrings.remove, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
