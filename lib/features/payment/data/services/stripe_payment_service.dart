import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/stripe_test_payment_sheet.dart';

class StripePaymentService extends GetxService {
  final isProcessing = false.obs;

  Future<bool> processPayment({
    required BuildContext context,
    required double amount,
  }) async {
    if (amount <= 0) return false;

    isProcessing.value = true;
    try {
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => StripeTestPaymentSheet(amount: amount),
      );

      return result == true;
    } finally {
      isProcessing.value = false;
    }
  }
}
