import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationAudience { buyer, seller }

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? orderId;
  final NotificationAudience audience;
  final DateTime time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.time,
    required this.audience,
    this.orderId,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      orderId: map['orderId'] as String?,
      audience: _audienceFromString(map['audience'] as String?),
      time: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  static NotificationAudience _audienceFromString(String? value) {
    if (value == 'seller') return NotificationAudience.seller;
    return NotificationAudience.buyer;
  }

  static String audienceToString(NotificationAudience audience) {
    switch (audience) {
      case NotificationAudience.buyer:
        return 'buyer';
      case NotificationAudience.seller:
        return 'seller';
    }
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      orderId: orderId,
      audience: audience,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}
