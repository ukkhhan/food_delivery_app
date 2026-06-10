import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/constants/order_constants.dart';
import '../../../../core/models/order_model.dart';
import '../../../cart/models/cart_item.dart';

class OrderRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.orders);

  Stream<List<OrderModel>> watchBuyerOrders(String buyerId) {
    return _collection
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map(_sortNewest);
  }

  Stream<List<OrderModel>> watchSellerOrders(String sellerId) {
    return _collection
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map(_sortNewest);
  }

  Future<List<OrderModel>> fetchBuyerOrders(String buyerId) async {
    final snapshot =
        await _collection.where('buyerId', isEqualTo: buyerId).get();
    return _sortNewest(snapshot);
  }

  Future<List<OrderModel>> fetchSellerOrders(String sellerId) async {
    final snapshot =
        await _collection.where('sellerId', isEqualTo: sellerId).get();
    return _sortNewest(snapshot);
  }

  Future<OrderModel> fetchOrder(String orderId) async {
    final snapshot = await _collection.doc(orderId).get();
    if (!snapshot.exists) {
      throw Exception('Order not found');
    }
    return OrderModel.fromMap(snapshot.id, snapshot.data()!);
  }

  Future<OrderModel> createOrder({
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required List<CartItem> items,
  }) async {
    final subtotal = items.fold<double>(0, (total, item) => total + item.total);
    const deliveryFee = OrderConstants.deliveryFee;
    final total = subtotal + deliveryFee;

    final doc = _collection.doc();
    final data = {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'status': OrderModel.statusToString(OrderStatus.placed),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'items': items.map((e) => OrderLine(item: e.product, quantity: e.quantity).toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await doc.set(data);
    return fetchOrder(doc.id);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _collection.doc(orderId).update({
      'status': OrderModel.statusToString(status),
    });
  }

  List<OrderModel> _sortNewest(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final items = snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
        .toList();
    items.sort(
      (a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
    );
    return items;
  }
}
