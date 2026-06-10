import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/my_text.dart';

class BuyerNotificationsView extends StatelessWidget {
  const BuyerNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.buyerNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const MyText.title(AppStrings.notifications),
        actions: [
          TextButton(
            onPressed: () {},
            child: const MyText.caption(AppStrings.markAllRead, color: AppColors.primary),
          ),
        ],
      ),
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
              itemBuilder: (_, i) => _NotificationTile(item: items[i]),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel item;

  const _NotificationTile({required this.item});

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

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
            Icons.notifications,
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
                const SizedBox(height: 6),
                MyText.caption(_timeAgo(item.time)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
