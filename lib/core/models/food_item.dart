import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String sellerId;
  final String? imageKey;
  final DateTime? createdAt;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.sellerId,
    this.imageKey,
    this.createdAt,
  });

  bool get hasImage => imageKey != null && imageKey!.isNotEmpty;

  factory FoodItem.fromMap(String id, Map<String, dynamic> map) {
    final created = map['createdAt'];
    return FoodItem(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      category: map['category'] as String? ?? '',
      sellerId: map['sellerId'] as String? ?? '',
      imageKey: map['imageKey'] as String?,
      createdAt: created is Timestamp ? created.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'sellerId': sellerId,
      if (imageKey != null) 'imageKey': imageKey,
    };
  }
}
