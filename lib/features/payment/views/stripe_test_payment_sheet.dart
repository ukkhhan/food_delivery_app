import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/stripe_config.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/my_text_field.dart';

class StripeTestPaymentSheet extends StatefulWidget {
  final double amount;

  const StripeTestPaymentSheet({super.key, required this.amount});

  @override
  State<StripeTestPaymentSheet> createState() => _StripeTestPaymentSheetState();
}

class _StripeTestPaymentSheetState extends State<StripeTestPaymentSheet> {
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController(text: '12/34');
  final _cvcController = TextEditingController(text: '123');
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  String get _cardDigits =>
      _cardController.text.replaceAll(RegExp(r'\s+'), '');

  bool get _isValidTestCard =>
      _cardDigits == StripeConfig.testCardNumber;

  Future<void> _pay() async {
    if (!_isValidTestCard) {
      setState(() {
        _error = AppStrings.stripeInvalidTestCard;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: MyText.title(
                  '${StripeConfig.merchantName} · ${AppStrings.stripeTestMode}',
                ),
              ),
              IconButton(
                onPressed: _loading ? null : () => Get.back(result: false),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 4),
          MyText.caption(
            '${AppStrings.stripePayAmount} \$${widget.amount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 20),
          MyTextField(
            label: AppStrings.cardNumber,
            hint: StripeConfig.testCardDisplay,
            controller: _cardController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ],
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  label: AppStrings.expiry,
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MyTextField(
                  label: AppStrings.cvc,
                  controller: _cvcController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: MyText.caption(
              '${AppStrings.stripeTestHint} ${StripeConfig.testCardDisplay}',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            MyText.caption(_error!, color: AppColors.error),
          ],
          const SizedBox(height: 20),
          MyButton(
            label: AppStrings.payNow,
            icon: Icons.credit_card,
            isLoading: _loading,
            onTap: _loading ? null : _pay,
          ),
        ],
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
