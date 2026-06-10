import '../../../core/models/order_model.dart';

class OrderStats {
  final int totalOrders;
  final int deliveredOrders;
  final int activeOrders;
  final int totalItems;
  final double totalAmount;

  const OrderStats({
    required this.totalOrders,
    required this.deliveredOrders,
    required this.activeOrders,
    required this.totalItems,
    required this.totalAmount,
  });

  factory OrderStats.fromOrders(List<OrderModel> orders) {
    final delivered =
        orders.where((o) => o.status == OrderStatus.delivered).length;

    return OrderStats(
      totalOrders: orders.length,
      deliveredOrders: delivered,
      activeOrders: orders.length - delivered,
      totalItems: orders.fold<int>(
        0,
        (sum, order) =>
            sum + order.lines.fold<int>(0, (s, line) => s + line.quantity),
      ),
      totalAmount: orders.fold<double>(0, (sum, order) => sum + order.total),
    );
  }
}
