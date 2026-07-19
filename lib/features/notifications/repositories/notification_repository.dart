import '../models/app_notification.dart';

abstract class NotificationRepository {
  Stream<List<AppNotification>> watchNotifications();

  Future<List<AppNotification>> getAllNotifications();

  Future<void> saveNotification(AppNotification notification);

  Future<void> markAsRead(int id);

  Future<void> markAllAsRead();

  Future<void> archiveNotification(int id);

  Future<void> pinNotification(int id, bool pinned);

  Future<void> deleteNotification(int id);

  Future<void> clearReadNotifications();

  Future<void> deleteAllNotifications();
}
