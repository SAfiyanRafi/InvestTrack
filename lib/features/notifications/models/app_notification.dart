import 'package:isar/isar.dart';

part 'app_notification.g.dart';

enum NotificationType { informational, success, warning, critical }

enum NotificationCategory {
  financial,
  business,
  reports,
  documents,
  reminder,
  system,
}

@collection
class AppNotification {
  Id id = Isar.autoIncrement;

  @Index()
  late String title;

  late String body;

  @Index()
  late DateTime timestamp;

  @enumerated
  @Index()
  late NotificationType type;

  @enumerated
  @Index()
  late NotificationCategory category;

  @Index()
  bool isRead = false;

  bool pinned = false;

  bool archived = false;

  bool deleted = false;

  String? actionRoute;

  int? relatedBusinessId;

  int? relatedTransactionId;

  int? relatedDocumentId;

  int? relatedReminderId;
}
