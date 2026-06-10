import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/notification_model.dart';
import 'my_text.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final IconData icon;

  const NotificationTile({
    super.key,
    required this.item,
    this.icon = Icons.notifications,
  });

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
            icon,
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
