import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/notifications/controllers/notification_controller.dart';
import 'features/notifications/data/repositories/notification_repository.dart';
import 'features/orders/data/repositories/order_repository.dart';
import 'features/payment/data/services/stripe_payment_service.dart';
import 'features/products/data/local/product_image_db.dart';
import 'features/products/data/repositories/product_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<AuthService>(() async => AuthService().init());
  await Get.putAsync<ProductImageDb>(() async => ProductImageDb().init());
  Get.put(StripePaymentService(), permanent: true);
  Get.put(ProductRepository(), permanent: true);
  Get.put(OrderRepository(), permanent: true);
  Get.put(NotificationRepository(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
