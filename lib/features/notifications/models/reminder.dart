import 'package:isar/isar.dart';

part 'reminder.g.dart';

enum ReminderRepeat {
  none,
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

enum ReminderPriority {
  low,
  medium,
  high,
  critical,
}

enum ReminderCategory {
  custom,
  investmentReview,
  loanPayment,
  taxReminder,
  businessReview,
  documentExpiry,
  monthlyReview,
  dividendReview,
  quarterlyReport,
}

@collection
class Reminder {
  Id id = Isar.autoIncrement;

  @Index()
  late String title;

  String? description;

  @Index()
  late DateTime dueDate;

  @enumerated
  late ReminderRepeat repeat;

  int? customIntervalDays;

  @enumerated
  @Index()
  late ReminderPriority priority;

  @enumerated
  @Index()
  late ReminderCategory category;

  @Index()
  int? businessId;

  @Index()
  int? transactionId;

  String? notes;

  @Index()
  bool completed = false;

  bool archived = false;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? completedAt;

  DateTime? lastNotifiedAt;
}
