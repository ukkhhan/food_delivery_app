import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../../orders/controllers/order_controller.dart';
import '../../../payment/data/services/stripe_payment_service.dart';

class CheckoutView extends GetView<CartController> {
  const CheckoutView({super.key});

  OrderController get _orderController => Get.find<OrderController>();
  StripePaymentService get _stripe => Get.find<StripePaymentService>();
  AuthService get _auth => Get.find<AuthService>();

  Future<void> _payAndPlaceOrder(BuildContext context) async {
    if (controller.isEmpty) return;

    if (_auth.user.value == null) return;

    final paid = await _stripe.processPayment(
      context: context,
      amount: controller.total,
    );

    if (!paid) return;

    final order = await _orderController.placeOrder(controller.items.toList());
    if (order == null) return;

    controller.clear();
    Get.back();
    Get.snackbar(
      AppStrings.orderPlaced,
      AppStrings.orderPlacedSuccess,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    Get.toNamed(AppRoutes.orderDetail, arguments: order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.checkout)),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const MyText.title(AppStrings.orderSummary),
            const SizedBox(height: 12),
            ...controller.items.map(
              (line) => _line(
                '${line.product.name} x${line.quantity}',
                line.total,
              ),
            ),
            const Divider(height: 28),
            _line(AppStrings.subtotal, controller.subtotal),
            _line(AppStrings.deliveryFee, controller.deliveryFee),
            const SizedBox(height: 8),
            _line(AppStrings.total, controller.total, highlight: true),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chipBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        MyText.subtitle('Stripe Test Mode'),
                        SizedBox(height: 2),
                        MyText.caption('Use test card 4242 4242 4242 4242'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final loading = _stripe.isProcessing.value ||
                _orderController.isProcessing.value;

            return MyButton(
              label: AppStrings.payWithStripe,
              icon: Icons.lock_outline,
              isLoading: loading,
              onTap: () => _payAndPlaceOrder(context),
            );
          }),
        ),
      ),
    );
  }

  Widget _line(String label, double amount, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: MyText.body(
              label,
              weight: highlight ? FontWeight.w600 : null,
            ),
          ),
          MyText.body(
            '\$${amount.toStringAsFixed(2)}',
            weight: highlight ? FontWeight.w700 : null,
            color: highlight ? AppColors.primary : null,
          ),
        ],
      ),
    );
  }
}
