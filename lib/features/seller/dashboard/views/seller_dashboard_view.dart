import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/order_status_chip.dart';
import '../../../../core/widgets/order_tracking_steps.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../orders/controllers/order_controller.dart';

class SellerDashboardView extends GetView<OrderController> {
  const SellerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.incomingOrders)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final activeOrders = controller.activeSellerOrders;
        if (activeOrders.isEmpty) {
          return const EmptyState(
            icon: Icons.inbox_outlined,
            title: AppStrings.noSellerOrders,
            subtitle: AppStrings.noOrdersHint,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeOrders.length,
          itemBuilder: (_, i) => _SellerOrderCard(order: activeOrders[i]),
        );
      }),
    );
  }
}

class _SellerOrderCard extends GetView<OrderController> {
  final OrderModel order;

  const _SellerOrderCard({required this.order});

  String? _actionLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return AppStrings.markPreparing;
      case OrderStatus.preparing:
        return AppStrings.markOnTheWay;
      case OrderStatus.onTheWay:
        return AppStrings.markDelivered;
      case OrderStatus.delivered:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items =
        order.lines.map((l) => '${l.item.name} x${l.quantity}').join(', ');
    final nextStatus = order.nextStatus;
    final actionLabel = nextStatus != null ? _actionLabel(order.status) : null;

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
              MyText.subtitle(order.displayId),
              const Spacer(),
              OrderStatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          MyText.caption('${order.buyerName} · $items'),
          const SizedBox(height: 4),
          MyText.label('\$${order.total.toStringAsFixed(2)}', color: AppColors.primary),
          const SizedBox(height: 16),
          const MyText.caption(AppStrings.trackOrder),
          const SizedBox(height: 8),
          OrderTrackingSteps(status: order.status, compact: true),
          if (actionLabel != null && nextStatus != null) ...[
            const SizedBox(height: 12),
            Obx(
              () => MyButton(
                label: actionLabel,
                isLoading: controller.isProcessing.value,
                onTap: () {
                  final latest = controller.orders.firstWhere(
                    (o) => o.id == order.id,
                    orElse: () => order,
                  );
                  final next = latest.nextStatus;
                  if (next != null) {
                    controller.updateStatus(latest, next);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
