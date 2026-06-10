import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;

  UserModel? get currentUser => _authService.user.value;

  bool get isLoggedIn => currentUser != null;

  bool get isSeller => currentUser?.isSeller ?? false;

  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final profile = await _authService.signInWithGoogle();
      _goToShell(profile.isSeller);
    } catch (e) {
      Get.snackbar(
        AppStrings.signInFailed,
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> switchRole(bool seller) async {
    final role = seller ? 'seller' : 'buyer';
    if (currentUser?.role == role) return;

    try {
      await _authService.updateRole(role);
      Get.offAllNamed(seller ? AppRoutes.sellerShell : AppRoutes.buyerShell);
    } catch (e) {
      Get.snackbar(
        AppStrings.signInFailed,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void routeFromSession() {
    if (!isLoggedIn) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    _goToShell(isSeller);
  }

  void _goToShell(bool seller) {
    Get.offAllNamed(seller ? AppRoutes.sellerShell : AppRoutes.buyerShell);
  }
}
