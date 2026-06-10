import 'package:get/get.dart';

import '../../../../core/models/order_model.dart';
import '../../../cart/models/cart_item.dart';
import '../remote/order_remote_service.dart';

class OrderRepository extends GetxService {
  final OrderRemoteService _remote = OrderRemoteService();

  Stream<List<OrderModel>> watchBuyerOrders(String buyerId) =>
      _remote.watchBuyerOrders(buyerId);

  Stream<List<OrderModel>> watchSellerOrders(String sellerId) =>
      _remote.watchSellerOrders(sellerId);

  Future<List<OrderModel>> fetchBuyerOrders(String buyerId) =>
      _remote.fetchBuyerOrders(buyerId);

  Future<List<OrderModel>> fetchSellerOrders(String sellerId) =>
      _remote.fetchSellerOrders(sellerId);

  Future<OrderModel> createOrder({
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required List<CartItem> items,
  }) {
    return _remote.createOrder(
      buyerId: buyerId,
      buyerName: buyerName,
      sellerId: sellerId,
      items: items,
    );
  }

  Future<void> updateStatus(String orderId, OrderStatus status) =>
      _remote.updateStatus(orderId, status);
}
