import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/order_model.dart';
import '../../auth/data/services/auth_service.dart';
import '../../cart/models/cart_item.dart';
import '../../notifications/data/repositories/notification_repository.dart';
import '../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  OrderController({required this.sellerMode});

  final bool sellerMode;
  final OrderRepository _repository = Get.find<OrderRepository>();
  final NotificationRepository _notifications = Get.find<NotificationRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;
  final isProcessing = false.obs;
  final processingOrderId = RxnString();

  StreamSubscription<List<OrderModel>>? _subscription;

  List<OrderModel> get activeSellerOrders => orders
      .where((order) => order.status != OrderStatus.delivered)
      .toList();

  @override
  void onInit() {
    super.onInit();
    _initOrders();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _initOrders() async {
    await refreshOrders(showLoading: true);
    _listenToOrders();
  }

  Future<void> refreshOrders({bool showLoading = false}) async {
    final userId = _authService.user.value?.uid;
    if (userId == null) {
      orders.clear();
      isLoading.value = false;
      return;
    }

    if (showLoading) isLoading.value = true;

    try {
      final items = sellerMode
          ? await _repository.fetchSellerOrders(userId)
          : await _repository.fetchBuyerOrders(userId);
      orders.assignAll(items);
    } catch (_) {
      if (showLoading) orders.clear();
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  void _listenToOrders() {
    final userId = _authService.user.value?.uid;
    if (userId == null) return;

    _subscription?.cancel();
    final stream = sellerMode
        ? _repository.watchSellerOrders(userId)
        : _repository.watchBuyerOrders(userId);

    _subscription = stream.listen(
      (items) => orders.assignAll(items),
      cancelOnError: false,
    );
  }

  Future<OrderModel?> placeOrder(List<CartItem> cartItems) async {
    final user = _authService.user.value;
    if (user == null || cartItems.isEmpty) return null;

    final sellerId = cartItems.first.product.sellerId;
    if (sellerId.isEmpty) return null;

    isProcessing.value = true;
    try {
      final order = await _repository.createOrder(
        buyerId: user.uid,
        buyerName: user.name,
        sellerId: sellerId,
        items: cartItems,
      );
      try {
        await _notifications.notifyOrderPlaced(order);
      } catch (_) {}
      await refreshOrders();
      return order;
    } catch (e) {
      Get.snackbar(
        AppStrings.saveFailed,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return null;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    final previous = orders[index];
    isProcessing.value = true;
    processingOrderId.value = orderId;

    orders[index] = previous.copyWith(status: status);
    orders.refresh();

    try {
      await _repository.updateStatus(orderId, status);
      try {
        await _notifications.notifyStatusUpdate(
          previous.copyWith(status: status),
          status,
        );
      } catch (_) {}
    } catch (e) {
      orders[index] = previous;
      orders.refresh();
      Get.snackbar(
        AppStrings.saveFailed,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isProcessing.value = false;
      processingOrderId.value = null;
    }
  }
}
