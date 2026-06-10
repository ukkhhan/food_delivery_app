import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/my_text.dart';

class SellerNotificationsView extends StatelessWidget {
  const SellerNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.sellerNotifications;

    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.notifications)),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_none,
              title: AppStrings.noNotifications,
              subtitle: AppStrings.noNotificationsHint,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _Tile(item: items[i]),
            ),
    );
  }
}

class _Tile extends StatelessWidget {
  final NotificationModel item;

  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead ? AppColors.surface : AppColors.chipBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.title.contains('delivered') ? Icons.check_circle : Icons.shopping_bag,
            color: item.isRead ? AppColors.textHint : AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.subtitle(item.title),
                const SizedBox(height: 4),
                MyText.caption(item.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
