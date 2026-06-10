import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/widgets/order_status_chip.dart';
import '../../../../core/widgets/order_tracking_steps.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../orders/controllers/order_controller.dart';

class OrderDetailView extends GetView<OrderController> {
  const OrderDetailView({super.key});

  OrderModel get _initialOrder => Get.arguments as OrderModel;

  OrderModel get _order {
    return controller.orders.firstWhere(
      (o) => o.id == _initialOrder.id,
      orElse: () => _initialOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.orderDetails)),
      body: Obx(() {
        final order = _order;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                MyText.title(order.displayId),
                const Spacer(),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 24),
            const MyText.subtitle(AppStrings.trackOrder),
            const SizedBox(height: 16),
            OrderTrackingSteps(status: order.status),
            const SizedBox(height: 24),
            const MyText.subtitle(AppStrings.orderSummary),
            const SizedBox(height: 12),
            ...order.lines.map(
              (line) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: MyText.body('${line.item.name} x${line.quantity}'),
                    ),
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
        );
      }),
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
