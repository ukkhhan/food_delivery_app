class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}
