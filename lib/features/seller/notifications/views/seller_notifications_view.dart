import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/notification_tile.dart';
import '../../../notifications/controllers/notification_controller.dart';

class SellerNotificationsView extends GetView<NotificationController> {
  const SellerNotificationsView({super.key});

  IconData _iconFor(NotificationModel item) {
    if (item.title.toLowerCase().contains('delivered')) {
      return Icons.check_circle;
    }
    return Icons.shopping_bag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.notifications)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.forAudience(NotificationAudience.seller);
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_none,
            title: AppStrings.noNotifications,
            subtitle: AppStrings.noNotificationsHint,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => NotificationTile(
            item: items[i],
            icon: _iconFor(items[i]),
          ),
        );
      }),
    );
  }
}
