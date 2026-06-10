import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/order_status_chip.dart';
import '../../../../core/widgets/my_text.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = MockData.orders;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.orderHistory)),
      body: orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.noOrdersYet,
              subtitle: AppStrings.noOrdersHint,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} · ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = order.lines.fold<int>(0, (s, l) => s + l.quantity);

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MyText.subtitle(order.id),
                const Spacer(),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 6),
            MyText.caption('$itemCount items · \$${order.total.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            MyText.caption(_formatDate(order.createdAt)),
          ],
        ),
      ),
    );
  }
}
