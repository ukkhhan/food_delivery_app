import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/food_item.dart';
import '../../auth/data/services/auth_service.dart';
import '../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  ProductController({required this.sellerMode});

  final bool sellerMode;
  final ProductRepository _repository = Get.find<ProductRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final products = <FoodItem>[].obs;
  final isLoading = true.obs;
  final isSaving = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;

  StreamSubscription<List<FoodItem>>? _subscription;

  List<String> get categories {
    final cats =
        products.map((p) => p.category).where((c) => c.isNotEmpty).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<FoodItem> get filteredProducts {
    final query = searchQuery.value.toLowerCase();
    return products.where((item) {
      final matchesCategory = selectedCategory.value == 'All' ||
          item.category == selectedCategory.value;
      final matchesSearch =
          query.isEmpty || item.name.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initProducts();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _initProducts() async {
    await refreshProducts(showLoading: true);
    _listenToProducts();
  }

  Future<void> refreshProducts({bool showLoading = false}) async {
    final sellerId = _authService.user.value?.uid;

    if (sellerMode && sellerId == null) {
      products.clear();
      isLoading.value = false;
      return;
    }

    if (showLoading) isLoading.value = true;

    try {
      final items = sellerMode
          ? await _repository.fetchSellerProducts(sellerId!)
          : await _repository.fetchAllProducts();
      products.assignAll(items);
    } catch (_) {
      if (showLoading) products.clear();
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  void _listenToProducts() {
    final sellerId = _authService.user.value?.uid;
    if (sellerMode && sellerId == null) return;

    _subscription?.cancel();
    final stream = sellerMode
        ? _repository.watchSellerProducts(sellerId!)
        : _repository.watchAllProducts();

    _subscription = stream.listen(
      (items) => products.assignAll(items),
      cancelOnError: false,
    );
  }

  void setSearch(String value) => searchQuery.value = value;

  void setCategory(String value) => selectedCategory.value = value;

  Future<bool> saveProduct({
    FoodItem? existing,
    required String name,
    required String description,
    required double price,
    required String category,
    Uint8List? imageBytes,
  }) async {
    final sellerId = _authService.user.value?.uid;
    if (sellerId == null) return false;

    isSaving.value = true;
    try {
      if (existing == null) {
        await _repository.createProduct(
          sellerId: sellerId,
          name: name,
          description: description,
          price: price,
          category: category,
          imageBytes: imageBytes,
        );
      } else {
        await _repository.updateProduct(
          id: existing.id,
          name: name,
          description: description,
          price: price,
          category: category,
          existingImageKey: existing.imageKey,
          imageBytes: imageBytes,
        );
      }
      await refreshProducts();
      return true;
    } catch (e) {
      Get.snackbar(
        AppStrings.saveFailed,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteProduct(FoodItem item) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(AppStrings.delete),
        content: const Text(AppStrings.confirmDeleteProduct),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await _repository.deleteProduct(item.id);
      await refreshProducts();
      Get.back();
      Get.snackbar(
        AppStrings.delete,
        AppStrings.productDeleted,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.saveFailed,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
