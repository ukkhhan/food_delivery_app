import '../../../core/models/food_item.dart';

class CartItem {
  final FoodItem product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}
