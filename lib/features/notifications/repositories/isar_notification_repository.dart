import 'package:isar/isar.dart';

import '../models/app_notification.dart';
import 'notification_repository.dart';

class IsarNotificationRepository implements NotificationRepository {
  const IsarNotificationRepository(this._isar);

  final Isar _isar;

  @override
  Stream<List<AppNotification>> watchNotifications() {
    return _isar.appNotifications.where().watch(fireImmediately: true);
  }

  @override
  Future<List<AppNotification>> getAllNotifications() {
    return _isar.appNotifications.where().findAll();
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    await _isar.writeTxn(() async {
      await _isar.appNotifications.put(notification);
    });
  }

  @override
  Future<void> markAsRead(int id) async {
    final existing = await _isar.appNotifications.get(id);
    if (existing == null) return;

    existing.isRead = true;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.put(existing);
    });
  }

  @override
  Future<void> markAllAsRead() async {
    final unread = await _isar.appNotifications.filter().isReadEqualTo(false).findAll();
    if (unread.isEmpty) return;

    for (final item in unread) {
      item.isRead = true;
    }

    await _isar.writeTxn(() async {
      await _isar.appNotifications.putAll(unread);
    });
  }

  @override
  Future<void> archiveNotification(int id) async {
    final existing = await _isar.appNotifications.get(id);
    if (existing == null) return;

    existing.archived = true;
    existing.isRead = true;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.put(existing);
    });
  }

  @override
  Future<void> pinNotification(int id, bool pinned) async {
    final existing = await _isar.appNotifications.get(id);
    if (existing == null) return;

    existing.pinned = pinned;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.put(existing);
    });
  }

  @override
  Future<void> deleteNotification(int id) async {
    await _isar.writeTxn(() async {
      await _isar.appNotifications.delete(id);
    });
  }

  @override
  Future<void> clearReadNotifications() async {
    final read = await _isar.appNotifications.filter().isReadEqualTo(true).idProperty().findAll();
    if (read.isEmpty) return;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.deleteAll(read);
    });
  }

  @override
  Future<void> deleteAllNotifications() async {
    final ids = await _isar.appNotifications.where().idProperty().findAll();
    if (ids.isEmpty) return;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.deleteAll(ids);
    });
  }
}
