import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/widgets/order_status_chip.dart';
import '../../../../core/widgets/my_text.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.orderDetails)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              MyText.title(order.id),
              const Spacer(),
              OrderStatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 24),
          const MyText.subtitle(AppStrings.trackOrder),
          const SizedBox(height: 16),
          _step(AppStrings.orderPlaced, true),
          _step(AppStrings.preparing, order.status.index >= 1),
          _step(AppStrings.onTheWay, order.status.index >= 2),
          _step(AppStrings.delivered, order.status == OrderStatus.delivered),
          const SizedBox(height: 24),
          const MyText.subtitle(AppStrings.orderSummary),
          const SizedBox(height: 12),
          ...order.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: MyText.body('${line.item.name} x${line.quantity}')),
                  MyText.body('\$${line.total.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const Divider(height: 28),
          _totalRow(AppStrings.subtotal, order.subtotal),
          _totalRow(AppStrings.deliveryFee, order.deliveryFee),
          _totalRow(AppStrings.total, order.total, bold: true),
        ],
      ),
    );
  }

  Widget _step(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppColors.primary : AppColors.border,
            ),
            child: done
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          MyText.body(label, color: done ? AppColors.textPrimary : AppColors.textHint),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double amount, {bool bold = false}) {
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
