import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'my_text.dart';

class OrderHistoryStats extends StatelessWidget {
  final String totalLabel;
  final String deliveredLabel;
  final String itemsLabel;
  final String amountLabel;
  final int totalOrders;
  final int deliveredOrders;
  final int totalItems;
  final double totalAmount;

  const OrderHistoryStats({
    super.key,
    required this.totalLabel,
    required this.deliveredLabel,
    required this.itemsLabel,
    required this.amountLabel,
    required this.totalOrders,
    required this.deliveredOrders,
    required this.totalItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: totalLabel,
                value: '$totalOrders',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: deliveredLabel,
                value: '$deliveredOrders',
                icon: Icons.check_circle_outline,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: itemsLabel,
                value: '$totalItems',
                icon: Icons.fastfood_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: amountLabel,
                value: '\$${totalAmount.toStringAsFixed(2)}',
                icon: Icons.payments_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.secondary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: accent),
          const SizedBox(height: 8),
          MyText.title(value, color: accent),
          const SizedBox(height: 2),
          MyText.caption(label),
        ],
      ),
    );
  }
}
