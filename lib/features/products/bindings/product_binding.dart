import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  final bool sellerMode;

  ProductBinding({required this.sellerMode});

  @override
  void dependencies() {
    Get.put(ProductController(sellerMode: sellerMode));
  }
}
