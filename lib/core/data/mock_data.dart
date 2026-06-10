import '../models/notification_model.dart';

class MockData {
  static final buyerNotifications = [
    NotificationModel(
      id: 'n1',
      title: 'Order received',
      body: 'ORD-1042 is confirmed. Kitchen started preparing.',
      time: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    NotificationModel(
      id: 'n2',
      title: 'Out for delivery',
      body: 'Your pizza is on the way.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
  ];

  static final sellerNotifications = [
    NotificationModel(
      id: 's1',
      title: 'New order',
      body: 'ORD-1042 from Alex — 2 items.',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    NotificationModel(
      id: 's2',
      title: 'Order delivered',
      body: 'ORD-1038 marked as delivered.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
}
