import 'package:get/get.dart';

import '../../auth/bindings/auth_binding.dart';
import '../../orders/bindings/order_binding.dart';
import 'product_binding.dart';

class SellerShellBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    ProductBinding(sellerMode: true).dependencies();
    OrderBinding(sellerMode: true).dependencies();
  }
}
