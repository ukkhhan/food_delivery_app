import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/notification_model.dart'
    show NotificationAudience, NotificationModel;
import '../../../../core/models/order_model.dart';
import '../remote/notification_remote_service.dart';

class NotificationRepository extends GetxService {
  final NotificationRemoteService _remote = NotificationRemoteService();

  Stream<List<NotificationModel>> watchForUser(String userId) =>
      _remote.watchForUser(userId);

  Future<List<NotificationModel>> fetchForUser(String userId) =>
      _remote.fetchForUser(userId);

  Future<void> markAllRead(
    String userId,
    NotificationAudience audience,
  ) =>
      _remote.markAllRead(userId, audience);

  Future<void> notifyOrderPlaced(OrderModel order) async {
    final itemCount =
        order.lines.fold<int>(0, (total, line) => total + line.quantity);

    await Future.wait([
      _remote.create(
        userId: order.buyerId,
        title: AppStrings.notifOrderPlacedTitle,
        body: AppStrings.notifOrderPlacedBody(order.displayId),
        audience: NotificationAudience.buyer,
        orderId: order.id,
      ),
      _remote.create(
        userId: order.sellerId,
        title: AppStrings.notifNewOrderTitle,
        body: AppStrings.notifNewOrderBody(
          order.displayId,
          order.buyerName,
          itemCount,
        ),
        audience: NotificationAudience.seller,
        orderId: order.id,
      ),
    ]);
  }

  Future<void> notifyStatusUpdate(OrderModel order, OrderStatus status) async {
    switch (status) {
      case OrderStatus.preparing:
        await _remote.create(
          userId: order.buyerId,
          title: AppStrings.notifPreparingTitle,
          body: AppStrings.notifPreparingBody(order.displayId),
          audience: NotificationAudience.buyer,
          orderId: order.id,
        );
      case OrderStatus.onTheWay:
        await _remote.create(
          userId: order.buyerId,
          title: AppStrings.notifOnTheWayTitle,
          body: AppStrings.notifOnTheWayBody(order.displayId),
          audience: NotificationAudience.buyer,
          orderId: order.id,
        );
      case OrderStatus.delivered:
        await Future.wait([
          _remote.create(
            userId: order.buyerId,
            title: AppStrings.notifDeliveredTitle,
            body: AppStrings.notifDeliveredBody(order.displayId),
            audience: NotificationAudience.buyer,
            orderId: order.id,
          ),
          _remote.create(
            userId: order.sellerId,
            title: AppStrings.notifOrderDeliveredTitle,
            body: AppStrings.notifOrderDeliveredBody(order.displayId),
            audience: NotificationAudience.seller,
            orderId: order.id,
          ),
        ]);
      case OrderStatus.placed:
        break;
    }
  }
}
