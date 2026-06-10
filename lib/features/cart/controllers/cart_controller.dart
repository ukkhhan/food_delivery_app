import 'package:get/get.dart';

import '../../../core/constants/order_constants.dart';
import '../../../core/models/food_item.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  final items = <CartItem>[].obs;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.total);

  double get deliveryFee =>
      items.isEmpty ? 0 : OrderConstants.deliveryFee;

  double get total => subtotal + deliveryFee;

  bool get isEmpty => items.isEmpty;

  String? get sellerId =>
      items.isEmpty ? null : items.first.product.sellerId;

  void addItem(FoodItem product, int quantity) {
    if (quantity < 1) return;

    final index = items.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }
    items.refresh();
  }

  void removeItem(String productId) {
    items.removeWhere((e) => e.product.id == productId);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 1) {
      removeItem(productId);
      return;
    }

    final index = items.indexWhere((e) => e.product.id == productId);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: quantity);
    items.refresh();
  }

  void clear() {
    items.clear();
  }
}
