import 'dart:async';

import 'package:get/get.dart';

import '../../../core/models/notification_model.dart'
    show NotificationAudience, NotificationModel;
import '../../auth/data/models/user_model.dart';
import '../../auth/data/services/auth_service.dart';
import '../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = Get.find<NotificationRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  StreamSubscription<List<NotificationModel>>? _subscription;
  StreamSubscription? _userSubscription;
  String? _activeUserId;

  List<NotificationModel> forAudience(NotificationAudience audience) =>
      notifications.where((n) => n.audience == audience).toList();

  int unreadCountFor(NotificationAudience audience) =>
      forAudience(audience).where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _userSubscription = _authService.user.listen(_onUserChanged);
    _onUserChanged(_authService.user.value);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  void _onUserChanged(UserModel? user) {
    if (user == null) {
      _subscription?.cancel();
      _subscription = null;
      _activeUserId = null;
      notifications.clear();
      isLoading.value = false;
      return;
    }

    if (_activeUserId == user.uid) return;

    _subscription?.cancel();
    _activeUserId = user.uid;
    _listen(user.uid, showLoading: notifications.isEmpty);
  }

  Future<void> _listen(String userId, {required bool showLoading}) async {
    if (showLoading) isLoading.value = true;

    try {
      final items = await _repository.fetchForUser(userId);
      if (_activeUserId != userId) return;
      notifications.assignAll(items);
    } catch (_) {
      if (_activeUserId == userId) notifications.clear();
    } finally {
      if (_activeUserId == userId) isLoading.value = false;
    }

    if (_activeUserId != userId) return;

    _subscription?.cancel();
    _subscription = _repository.watchForUser(userId).listen(
      (items) {
        if (_activeUserId == userId) notifications.assignAll(items);
      },
      cancelOnError: false,
    );
  }

  Future<void> markAllRead(NotificationAudience audience) async {
    final userId = _authService.user.value?.uid;
    if (userId == null || unreadCountFor(audience) == 0) return;

    await _repository.markAllRead(userId, audience);
  }
}
