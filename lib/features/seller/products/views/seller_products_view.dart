import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/food_image_box.dart';
import '../../../../core/widgets/my_text.dart';

class SellerProductsView extends StatelessWidget {
  const SellerProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final products = MockData.foods;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.manageProducts)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.productForm),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const MyText.label(AppStrings.addProduct, color: Colors.white),
      ),
      body: products.isEmpty
          ? const EmptyState(
              icon: Icons.restaurant_outlined,
              title: AppStrings.noProducts,
              subtitle: AppStrings.noProductsHint,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _ProductRow(item: products[i]),
            ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final FoodItem item;

  const _ProductRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.productForm, arguments: item),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            FoodImageBox(emoji: item.emoji, height: 56, width: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.subtitle(item.name),
                  MyText.caption(item.category),
                  MyText.label('\$${item.price.toStringAsFixed(2)}', color: AppColors.primary),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
