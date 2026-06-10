import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';
import 'my_text.dart';
import 'order_status_chip.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final String? subtitle;

  const OrderHistoryCard({
    super.key,
    required this.order,
    this.subtitle,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
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
                MyText.subtitle(order.displayId),
                const Spacer(),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 6),
            if (subtitle != null) ...[
              MyText.caption(subtitle!),
              const SizedBox(height: 4),
            ],
            MyText.caption('$itemCount items · \$${order.total.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            MyText.caption(_formatDate(order.createdAt)),
          ],
        ),
      ),
    );
  }
}
