import 'package:get/get.dart';

import '../../auth/bindings/auth_binding.dart';
import '../../orders/bindings/order_binding.dart';
import 'product_binding.dart';

class BuyerShellBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    ProductBinding(sellerMode: false).dependencies();
    OrderBinding(sellerMode: false).dependencies();
  }
}
