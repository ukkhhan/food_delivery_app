import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../core/models/food_item.dart';
import '../local/product_image_db.dart';
import '../remote/product_remote_service.dart';

class ProductRepository extends GetxService {
  final ProductRemoteService _remote = ProductRemoteService();
  final ProductImageDb _imageDb = Get.find<ProductImageDb>();

  final Map<String, Uint8List> _imageCache = {};

  Stream<List<FoodItem>> watchAllProducts() => _remote.watchAll();

  Stream<List<FoodItem>> watchSellerProducts(String sellerId) =>
      _remote.watchBySeller(sellerId);

  Future<List<FoodItem>> fetchAllProducts() => _remote.fetchAll();

  Future<List<FoodItem>> fetchSellerProducts(String sellerId) =>
      _remote.fetchBySeller(sellerId);

  Future<FoodItem> createProduct({
    required String sellerId,
    required String name,
    required String description,
    required double price,
    required String category,
    Uint8List? imageBytes,
  }) async {
    final id = await _remote.create({
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'sellerId': sellerId,
    });

    if (imageBytes != null) {
      await _imageDb.saveImage(id, imageBytes);
      _imageCache[id] = imageBytes;
    }

    return FoodItem(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      sellerId: sellerId,
    );
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    Uint8List? imageBytes,
  }) async {
    await _remote.update(id, {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    });

    if (imageBytes != null) {
      await _imageDb.saveImage(id, imageBytes);
      _imageCache[id] = imageBytes;
    }
  }

  Future<void> deleteProduct(String id) async {
    await _remote.delete(id);
    await _imageDb.deleteImage(id);
    _imageCache.remove(id);
  }

  Future<Uint8List?> getImage(String productId) async {
    if (_imageCache.containsKey(productId)) {
      return _imageCache[productId];
    }

    final bytes = await _imageDb.getImage(productId);
    if (bytes == null) return null;

    final data = Uint8List.fromList(bytes);
    _imageCache[productId] = data;
    return data;
  }

  void clearImageCache(String productId) => _imageCache.remove(productId);
}
