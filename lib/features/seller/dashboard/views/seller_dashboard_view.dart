import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/order_status_chip.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';

class SellerDashboardView extends StatelessWidget {
  const SellerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final activeOrders =
        MockData.orders.where((o) => o.status != OrderStatus.delivered).toList();

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.incomingOrders)),
      body: activeOrders.isEmpty
          ? const EmptyState(
              icon: Icons.inbox_outlined,
              title: AppStrings.noSellerOrders,
              subtitle: AppStrings.noOrdersHint,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeOrders.length,
              itemBuilder: (_, i) => _SellerOrderCard(order: activeOrders[i]),
            ),
    );
  }
}

class _SellerOrderCard extends StatelessWidget {
  final OrderModel order;

  const _SellerOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.lines.map((l) => '${l.item.name} x${l.quantity}').join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          MyText.caption('${order.buyerName} · $items'),
          const SizedBox(height: 4),
          MyText.label('\$${order.total.toStringAsFixed(2)}', color: AppColors.primary),
          const SizedBox(height: 12),
          if (order.status == OrderStatus.placed)
            MyButton(label: AppStrings.markPreparing, onTap: () {}),
          if (order.status == OrderStatus.preparing) ...[
            MyButton(label: AppStrings.markDelivered, onTap: () {}),
          ],
        ],
      ),
    );
  }
}
