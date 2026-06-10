import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../core/constants/image_refs.dart';
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

    String? imageKey;
    if (imageBytes != null) {
      imageKey = ImageRefs.localKey(id);
      await _imageDb.saveImage(id, imageBytes);
      _imageCache[imageKey] = imageBytes;
      await _remote.update(id, {'imageKey': imageKey});
    }

    return FoodItem(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      sellerId: sellerId,
      imageKey: imageKey,
    );
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    String? existingImageKey,
    Uint8List? imageBytes,
  }) async {
    final updates = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    };

    if (imageBytes != null) {
      final imageKey = ImageRefs.localKey(id);
      await _imageDb.saveImage(id, imageBytes);
      _imageCache[imageKey] = imageBytes;
      updates['imageKey'] = imageKey;
    } else if (existingImageKey != null) {
      updates['imageKey'] = existingImageKey;
    }

    await _remote.update(id, updates);
  }

  Future<void> deleteProduct(String id) async {
    await _remote.delete(id);
    await _imageDb.deleteImage(id);
    _imageCache.remove(ImageRefs.localKey(id));
  }

  Future<Uint8List?> getImageByRef(String? imageKey) async {
    final sqliteKey = ImageRefs.sqliteKeyFromRef(imageKey);
    if (sqliteKey == null) return null;

    if (_imageCache.containsKey(imageKey)) {
      return _imageCache[imageKey];
    }

    final bytes = await _imageDb.getImage(sqliteKey);
    if (bytes == null) return null;

    final data = Uint8List.fromList(bytes);
    _imageCache[imageKey!] = data;
    return data;
  }

  void clearImageCache(String? imageKey) {
    if (imageKey != null) _imageCache.remove(imageKey);
  }
}
