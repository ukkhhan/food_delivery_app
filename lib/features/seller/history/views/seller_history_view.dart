import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/order_history_card.dart';
import '../../../../core/widgets/order_history_stats.dart';
import '../../../orders/controllers/order_controller.dart';
import '../../../orders/utils/order_stats.dart';

class SellerHistoryView extends GetView<OrderController> {
  const SellerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.orderHistory)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.orders;
        final stats = OrderStats.fromOrders(orders);

        if (orders.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: AppStrings.noOrdersYet,
            subtitle: AppStrings.noOrdersHint,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length + 1,
          separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 16 : 10),
          itemBuilder: (_, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyText.subtitle(AppStrings.historySummary),
                  const SizedBox(height: 12),
                  OrderHistoryStats(
                    totalLabel: AppStrings.ordersReceived,
                    deliveredLabel: AppStrings.ordersDelivered,
                    itemsLabel: AppStrings.itemsSold,
                    amountLabel: AppStrings.totalRevenue,
                    totalOrders: stats.totalOrders,
                    deliveredOrders: stats.deliveredOrders,
                    totalItems: stats.totalItems,
                    totalAmount: stats.totalAmount,
                  ),
                  const SizedBox(height: 8),
                  MyText.caption(
                    '${AppStrings.activeOrders}: ${stats.activeOrders}',
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  const MyText.subtitle(AppStrings.pastOrders),
                ],
              );
            }

            final order = orders[i - 1];
            return OrderHistoryCard(
              order: order,
              subtitle: '${AppStrings.buyerMode}: ${order.buyerName}',
            );
          },
        );
      }),
    );
  }
}
