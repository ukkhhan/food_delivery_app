import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/order_model.dart';
import 'my_text.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = _style();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MyText.caption(label, color: color, weight: FontWeight.w600),
    );
  }

  (String, Color, Color) _style() {
    switch (status) {
      case OrderStatus.placed:
        return ('Placed', AppColors.warning, const Color(0xFFFFF7ED));
      case OrderStatus.preparing:
        return ('Preparing', AppColors.primary, AppColors.chipBg);
      case OrderStatus.onTheWay:
        return ('On the way', AppColors.secondary, const Color(0xFFE6FFFA));
      case OrderStatus.delivered:
        return ('Delivered', AppColors.success, const Color(0xFFECFDF5));
    }
  }
}
