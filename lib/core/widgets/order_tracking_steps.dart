import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/order_model.dart';
import 'my_text.dart';

class OrderTrackingSteps extends StatelessWidget {
  final OrderStatus status;
  final bool compact;

  const OrderTrackingSteps({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      (AppStrings.orderPlaced, OrderStatus.placed),
      (AppStrings.preparing, OrderStatus.preparing),
      (AppStrings.onTheWay, OrderStatus.onTheWay),
      (AppStrings.delivered, OrderStatus.delivered),
    ];

    return Column(
      children: steps.map((step) {
        final label = step.$1;
        final stepStatus = step.$2;
        final done = status.index >= stepStatus.index;
        final current = status == stepStatus;

        return Padding(
          padding: EdgeInsets.only(bottom: compact ? 8 : 12),
          child: Row(
            children: [
              Container(
                width: compact ? 20 : 24,
                height: compact ? 20 : 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.primary : AppColors.border,
                  border: current
                      ? Border.all(color: AppColors.primaryDark, width: 2)
                      : null,
                ),
                child: done
                    ? Icon(
                        Icons.check,
                        size: compact ? 12 : 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MyText.body(
                  label,
                  color: current
                      ? AppColors.primary
                      : done
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                  weight: current ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
