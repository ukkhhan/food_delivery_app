import 'package:cloud_firestore/cloud_firestore.dart';

import 'food_item.dart';

enum OrderStatus { placed, preparing, onTheWay, delivered }

class OrderLine {
  final FoodItem item;
  final int quantity;

  const OrderLine({required this.item, required this.quantity});

  double get total => item.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': item.id,
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'category': item.category,
      'sellerId': item.sellerId,
      'imageKey': item.imageKey,
      'quantity': quantity,
    };
  }

  factory OrderLine.fromMap(Map<String, dynamic> map) {
    return OrderLine(
      item: FoodItem(
        id: map['productId'] as String? ?? '',
        name: map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        category: map['category'] as String? ?? '',
        sellerId: map['sellerId'] as String? ?? '',
        imageKey: map['imageKey'] as String?,
      ),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final List<OrderLine> lines;
  final OrderStatus status;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.lines,
    required this.status,
    this.createdAt,
  });

  String get displayId {
    if (id.length <= 6) return 'ORD-$id';
    return 'ORD-${id.substring(id.length - 6).toUpperCase()}';
  }

  double get subtotal => lines.fold(0.0, (total, line) => total + line.total);

  double get deliveryFee => 2.99;

  double get total => subtotal + deliveryFee;

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    final lines = rawItems
        .map((e) => OrderLine.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    return OrderModel(
      id: id,
      buyerId: map['buyerId'] as String? ?? '',
      buyerName: map['buyerName'] as String? ?? '',
      sellerId: map['sellerId'] as String? ?? '',
      lines: lines,
      status: _statusFromString(map['status'] as String?),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static OrderStatus _statusFromString(String? value) {
    switch (value) {
      case 'placed':
        return OrderStatus.placed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'onTheWay':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.placed;
    }
  }

  bool hasReached(OrderStatus step) => status.index >= step.index;

  bool get isActive => status != OrderStatus.delivered;

  OrderStatus? get nextStatus {
    switch (status) {
      case OrderStatus.placed:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.onTheWay;
      case OrderStatus.onTheWay:
        return OrderStatus.delivered;
      case OrderStatus.delivered:
        return null;
    }
  }

  OrderModel copyWith({OrderStatus? status}) {
    return OrderModel(
      id: id,
      buyerId: buyerId,
      buyerName: buyerName,
      sellerId: sellerId,
      lines: lines,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  static String statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'placed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.onTheWay:
        return 'onTheWay';
      case OrderStatus.delivered:
        return 'delivered';
    }
  }
}
