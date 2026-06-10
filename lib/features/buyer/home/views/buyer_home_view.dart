import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../../products/controllers/product_controller.dart';

class BuyerHomeView extends GetView<ProductController> {
  const BuyerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText.title(AppStrings.appName),
        actions: [
          Obx(() {
            final count = Get.find<CartController>().itemCount;
            return IconButton(
              onPressed: () {},
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.filteredProducts;
        final categories = controller.categories;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              onChanged: controller.setSearch,
              decoration: const InputDecoration(
                hintText: AppStrings.searchFood,
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            const MyText.title(AppStrings.popularItems),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final selected = controller.selectedCategory.value == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => controller.setCategory(cat),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: MyText.caption(
                  AppStrings.noProductsHint,
                  align: TextAlign.center,
                ),
              )
            else
              ...items.map((item) => _FoodCard(item: item)),
          ],
        );
      }),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final FoodItem item;

  const _FoodCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ProductImage(imageKey: item.imageKey, productId: item.id, height: 72, width: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.subtitle(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  MyText.caption(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  MyText.label('\$${item.price.toStringAsFixed(2)}', color: AppColors.primary),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
