import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  final bool sellerMode;

  OrderBinding({required this.sellerMode});

  @override
  void dependencies() {
    Get.put(OrderController(sellerMode: sellerMode));
  }
}
