import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../models/notification_model.dart';
import '../../features/notifications/controllers/notification_controller.dart';

class NotificationBellIcon extends StatelessWidget {
  final NotificationAudience audience;
  final bool active;

  const NotificationBellIcon({
    super.key,
    required this.audience,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final hasUnread = controller.unreadCountFor(audience) > 0;
      final icon = Icon(
        active ? Icons.notifications : Icons.notifications_outlined,
      );

      if (!hasUnread) return icon;

      return Badge(
        isLabelVisible: false,
        backgroundColor: AppColors.error,
        smallSize: 9,
        alignment: AlignmentDirectional.topEnd,
        child: icon,
      );
    });
  }
}
