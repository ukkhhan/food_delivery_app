import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/models/food_item.dart';

class ProductRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.products);

  Stream<List<FoodItem>> watchAll() {
    return _collection.snapshots().map(_sortNewest);
  }

  Stream<List<FoodItem>> watchBySeller(String sellerId) {
    return _collection
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map(_sortNewest);
  }

  Future<List<FoodItem>> fetchAll() async {
    final snapshot = await _collection.get();
    return _sortNewest(snapshot);
  }

  Future<List<FoodItem>> fetchBySeller(String sellerId) async {
    final snapshot =
        await _collection.where('sellerId', isEqualTo: sellerId).get();
    return _sortNewest(snapshot);
  }

  Future<String> create(Map<String, dynamic> data) async {
    final doc = _collection.doc();
    await doc.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  List<FoodItem> _sortNewest(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final items = snapshot.docs
        .map((doc) => FoodItem.fromMap(doc.id, doc.data()))
        .toList();
    items.sort(
      (a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
    );
    return items;
  }
}
