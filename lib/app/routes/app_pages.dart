import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/buyer/checkout/views/checkout_view.dart';
import '../../features/buyer/orders/views/order_detail_view.dart';
import '../../features/buyer/product/views/product_detail_view.dart';
import '../../features/buyer/shell/buyer_shell_view.dart';
import '../../features/products/bindings/buyer_shell_binding.dart';
import '../../features/products/bindings/product_binding.dart';
import '../../features/products/bindings/seller_shell_binding.dart';
import '../../features/products/controllers/product_controller.dart';
import '../../features/seller/products/views/product_form_view.dart';
import '../../features/seller/shell/seller_shell_view.dart';
import '../../features/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.buyerShell,
      page: () => const BuyerShellView(),
      binding: BuyerShellBinding(),
    ),
    GetPage(
      name: AppRoutes.sellerShell,
      page: () => const SellerShellView(),
      binding: SellerShellBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
    ),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutView()),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailView()),
    GetPage(
      name: AppRoutes.productForm,
      page: () => const ProductFormView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ProductController>()) {
          ProductBinding(sellerMode: true).dependencies();
        }
      }),
    ),
  ];
}
