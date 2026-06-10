import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final subtotal = MockData.foods[0].price * 2 + MockData.foods[2].price;
    const delivery = 2.99;
    final total = subtotal + delivery;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.checkout)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MyText.title(AppStrings.orderSummary),
          const SizedBox(height: 12),
          _line('Classic Burger x2', MockData.foods[0].price * 2),
          _line('Iced Latte x1', MockData.foods[2].price),
          const Divider(height: 28),
          _line(AppStrings.subtotal, subtotal),
          _line(AppStrings.deliveryFee, delivery),
          const SizedBox(height: 8),
          _line(AppStrings.total, total, highlight: true),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      MyText.subtitle('Stripe Test Mode'),
                      SizedBox(height: 2),
                      MyText.caption('Card sheet opens on place order'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyButton(
                label: AppStrings.payWithStripe,
                icon: Icons.lock_outline,
                onTap: () {
                  Get.snackbar(
                    'Stripe',
                    'Payment sheet will connect in next step',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                },
              ),
              const SizedBox(height: 8),
              MyButton(
                label: AppStrings.placeOrder,
                outlined: true,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(String label, double amount, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: MyText.body(
              label,
              weight: highlight ? FontWeight.w600 : null,
            ),
          ),
          MyText.body(
            '\$${amount.toStringAsFixed(2)}',
            weight: highlight ? FontWeight.w700 : null,
            color: highlight ? AppColors.primary : null,
          ),
        ],
      ),
    );
  }
}
