import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/models/notification_model.dart'
    show NotificationAudience, NotificationModel;

class NotificationRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.notifications);

  Stream<List<NotificationModel>> watchForUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(_sortNewest);
  }

  Future<List<NotificationModel>> fetchForUser(String userId) async {
    final snapshot =
        await _collection.where('userId', isEqualTo: userId).get();
    return _sortNewest(snapshot);
  }

  Future<void> create({
    required String userId,
    required String title,
    required String body,
    required NotificationAudience audience,
    String? orderId,
  }) async {
    await _collection.add({
      'userId': userId,
      'title': title,
      'body': body,
      'audience': NotificationModel.audienceToString(audience),
      if (orderId != null) 'orderId': orderId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAllRead(
    String userId,
    NotificationAudience audience,
  ) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('audience', isEqualTo: NotificationModel.audienceToString(audience))
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      if (doc.data()['isRead'] == true) continue;
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  List<NotificationModel> _sortNewest(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final items = snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
        .toList();
    items.sort((a, b) => b.time.compareTo(a.time));
    return items;
  }
}
