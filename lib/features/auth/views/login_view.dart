import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  shape: BoxShape.circle,
                ),
                child: const Text('🍔', style: TextStyle(fontSize: 56)),
              ),
              const SizedBox(height: 28),
              const MyText.display(AppStrings.welcomeBack, align: TextAlign.center),
              const SizedBox(height: 8),
              const MyText.subtitle(
                AppStrings.signInToOrder,
                align: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const Spacer(flex: 3),
              Obx(
                () => MyButton(
                  label: AppStrings.continueWithGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  isLoading: controller.isLoading.value,
                  onTap: controller.signInWithGoogle,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
