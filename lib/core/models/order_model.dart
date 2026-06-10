import 'food_item.dart';

enum OrderStatus { placed, preparing, onTheWay, delivered }

class OrderLine {
  final FoodItem item;
  final int quantity;

  const OrderLine({required this.item, required this.quantity});

  double get total => item.price * quantity;
}

class OrderModel {
  final String id;
  final List<OrderLine> lines;
  final OrderStatus status;
  final DateTime createdAt;
  final String buyerName;

  const OrderModel({
    required this.id,
    required this.lines,
    required this.status,
    required this.createdAt,
    required this.buyerName,
  });

  double get subtotal => lines.fold(0, (sum, line) => sum + line.total);

  double get deliveryFee => 2.99;

  double get total => subtotal + deliveryFee;
}
