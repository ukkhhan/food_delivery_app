import 'dart:async';

import 'package:get/get.dart';

import '../../../core/models/notification_model.dart'
    show NotificationAudience, NotificationModel;
import '../../auth/data/services/auth_service.dart';
import '../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = Get.find<NotificationRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;

  StreamSubscription<List<NotificationModel>>? _subscription;
  StreamSubscription? _userSubscription;

  List<NotificationModel> forAudience(NotificationAudience audience) =>
      notifications.where((n) => n.audience == audience).toList();

  int unreadCountFor(NotificationAudience audience) =>
      forAudience(audience).where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _userSubscription = _authService.user.listen((user) {
      _subscription?.cancel();
      if (user == null) {
        notifications.clear();
        isLoading.value = false;
        return;
      }
      _listen(user.uid);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  Future<void> _listen(String userId) async {
    isLoading.value = true;
    try {
      final items = await _repository.fetchForUser(userId);
      notifications.assignAll(items);
    } catch (_) {
      notifications.clear();
    } finally {
      isLoading.value = false;
    }

    _subscription?.cancel();
    _subscription = _repository.watchForUser(userId).listen(
      (items) => notifications.assignAll(items),
      cancelOnError: false,
    );
  }

  Future<void> markAllRead(NotificationAudience audience) async {
    final userId = _authService.user.value?.uid;
    if (userId == null || unreadCountFor(audience) == 0) return;

    await _repository.markAllRead(userId, audience);
  }
}
