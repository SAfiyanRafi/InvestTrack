import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_database.dart';
import '../../../core/services/local_notification_service.dart';
import '../models/app_notification.dart';
import '../models/reminder.dart';
import '../repositories/isar_reminder_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/reminder_repository.dart';
import 'notification_provider.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarReminderRepository(isar);
});

final watchRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  final repo = ref.watch(reminderRepositoryProvider);
  return repo.watchReminders();
});

final activeRemindersProvider = Provider<AsyncValue<List<Reminder>>>((ref) {
  final asyncReminders = ref.watch(watchRemindersProvider);
  return asyncReminders.whenData((reminders) {
    final filtered = reminders
        .where((item) => !item.archived)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return filtered;
  });
});

enum ReminderStatus {
  upcoming,
  today,
  overdue,
  completed,
}

class ReminderStatusBuckets {
  const ReminderStatusBuckets({
    required this.today,
    required this.upcoming,
    required this.overdue,
    required this.completed,
  });

  final List<Reminder> today;
  final List<Reminder> upcoming;
  final List<Reminder> overdue;
  final List<Reminder> completed;
}

final reminderClockProvider = StreamProvider<DateTime>((ref) {
  final controller = StreamController<DateTime>();
  controller.add(DateTime.now());
  final timer = Timer.periodic(const Duration(minutes: 1), (_) {
    controller.add(DateTime.now());
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

final reminderStatusBucketsProvider = Provider<AsyncValue<ReminderStatusBuckets>>((ref) {
  final asyncReminders = ref.watch(activeRemindersProvider);
  final now = ref.watch(reminderClockProvider).valueOrNull ?? DateTime.now();

  return asyncReminders.whenData((reminders) {
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final today = <Reminder>[];
    final upcoming = <Reminder>[];
    final overdue = <Reminder>[];
    final completed = <Reminder>[];

    for (final reminder in reminders) {
      if (reminder.completed) {
        completed.add(reminder);
        continue;
      }

      if (reminder.dueDate.isBefore(todayStart)) {
        overdue.add(reminder);
        continue;
      }

      if (reminder.dueDate.isBefore(tomorrowStart)) {
        today.add(reminder);
        continue;
      }

      upcoming.add(reminder);
    }

    today.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    overdue.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    completed.sort((a, b) {
      final aAt = a.completedAt ?? a.updatedAt;
      final bAt = b.completedAt ?? b.updatedAt;
      return bAt.compareTo(aAt);
    });

    return ReminderStatusBuckets(
      today: today,
      upcoming: upcoming,
      overdue: overdue,
      completed: completed,
    );
  });
});

final todayRemindersProvider = Provider<List<Reminder>>((ref) {
  return ref.watch(reminderStatusBucketsProvider).valueOrNull?.today ?? const <Reminder>[];
});

final overdueRemindersProvider = Provider<List<Reminder>>((ref) {
  return ref.watch(reminderStatusBucketsProvider).valueOrNull?.overdue ?? const <Reminder>[];
});

final completedRemindersProvider = Provider<List<Reminder>>((ref) {
  return ref.watch(reminderStatusBucketsProvider).valueOrNull?.completed ?? const <Reminder>[];
});

final upcomingReminderProvider = Provider<Reminder?>((ref) {
  final upcoming = ref.watch(reminderStatusBucketsProvider).valueOrNull?.upcoming;
  if (upcoming == null || upcoming.isEmpty) {
    return null;
  }
  return upcoming.first;
});

final reminderScheduleSyncProvider = FutureProvider<void>((ref) async {
  final reminders = await ref.read(reminderRepositoryProvider).getAllReminders();
  for (final reminder in reminders) {
    if (reminder.archived || reminder.completed) {
      continue;
    }
    await LocalNotificationService.scheduleReminder(reminder);
  }
});

final reminderDueSyncProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(reminderRepositoryProvider);
  final notificationRepo = ref.read(notificationRepositoryProvider);
  final reminders = await repo.getAllReminders();
  final now = DateTime.now();

  for (final reminder in reminders) {
    if (reminder.archived || reminder.completed) {
      continue;
    }

    if (reminder.dueDate.isAfter(now)) {
      continue;
    }

    final lastNotifiedAt = reminder.lastNotifiedAt;
    final alreadyNotifiedToday =
        lastNotifiedAt != null &&
        lastNotifiedAt.year == now.year &&
        lastNotifiedAt.month == now.month &&
        lastNotifiedAt.day == now.day;

    if (alreadyNotifiedToday) {
      continue;
    }

    final notification = AppNotification()
      ..title = 'Reminder Due: ${reminder.title}'
      ..body = reminder.description ?? 'This reminder is due now.'
      ..timestamp = now
      ..type = reminder.priority == ReminderPriority.critical
          ? NotificationType.critical
          : NotificationType.warning
      ..category = NotificationCategory.reminder
      ..isRead = false
      ..relatedBusinessId = reminder.businessId
      ..relatedTransactionId = reminder.transactionId
      ..relatedReminderId = reminder.id
      ..actionRoute = '/notifications';

    await notificationRepo.saveNotification(notification);

    reminder.lastNotifiedAt = now;
    reminder.updatedAt = now;
    await repo.saveReminder(reminder);
  }
});

class ReminderManager {
  const ReminderManager(this._ref);

  final Ref _ref;

  ReminderRepository get _repo => _ref.read(reminderRepositoryProvider);
  NotificationRepository get _notificationRepo =>
      _ref.read(notificationRepositoryProvider);

  Future<void> saveReminder(Reminder reminder) async {
    final isNew = reminder.id == 0;

    if (isNew) {
      final now = DateTime.now();
      reminder.createdAt = now;
      reminder.updatedAt = now;
    } else {
      reminder.updatedAt = DateTime.now();
    }

    await _repo.saveReminder(reminder);
    await LocalNotificationService.scheduleReminder(reminder);

    final notification = AppNotification()
      ..title = isNew ? 'Reminder created' : 'Reminder updated'
      ..body = reminder.title
      ..timestamp = DateTime.now()
      ..type = NotificationType.informational
      ..category = NotificationCategory.reminder
      ..relatedBusinessId = reminder.businessId
      ..relatedTransactionId = reminder.transactionId
      ..relatedReminderId = reminder.id
      ..actionRoute = '/reminders/${reminder.id}/edit';

    await _notificationRepo.saveNotification(notification);
  }

  Future<void> completeReminder(Reminder reminder) async {
    reminder.completed = true;
    reminder.completedAt = DateTime.now();
    reminder.updatedAt = DateTime.now();
    await _repo.saveReminder(reminder);
    await LocalNotificationService.cancelReminder(reminder.id);

    final notification = AppNotification()
      ..title = 'Reminder completed'
      ..body = reminder.title
      ..timestamp = DateTime.now()
      ..type = NotificationType.success
      ..category = NotificationCategory.reminder
      ..relatedReminderId = reminder.id;

    await _notificationRepo.saveNotification(notification);
  }

  Future<void> dismissReminder(Reminder reminder) async {
    reminder.archived = true;
    reminder.updatedAt = DateTime.now();
    await _repo.saveReminder(reminder);
    await LocalNotificationService.cancelReminder(reminder.id);
  }

  Future<void> archiveReminder(Reminder reminder) async {
    reminder.archived = true;
    reminder.updatedAt = DateTime.now();
    await _repo.saveReminder(reminder);
    await LocalNotificationService.cancelReminder(reminder.id);
  }

  Future<void> rescheduleReminder(Reminder reminder, DateTime newDate) async {
    reminder.dueDate = newDate;
    reminder.updatedAt = DateTime.now();
    reminder.lastNotifiedAt = null;
    await _repo.saveReminder(reminder);
    await LocalNotificationService.scheduleReminder(reminder);
  }

  Future<void> duplicateReminder(Reminder reminder) async {
    final now = DateTime.now();
    final duplicated = Reminder()
      ..title = '${reminder.title} (Copy)'
      ..description = reminder.description
      ..dueDate = reminder.dueDate.add(const Duration(days: 1))
      ..repeat = reminder.repeat
      ..customIntervalDays = reminder.customIntervalDays
      ..priority = reminder.priority
      ..category = reminder.category
      ..businessId = reminder.businessId
      ..transactionId = reminder.transactionId
      ..notes = reminder.notes
      ..completed = false
      ..archived = false
      ..createdAt = now
      ..updatedAt = now;

    await _repo.saveReminder(duplicated);
    await LocalNotificationService.scheduleReminder(duplicated);
  }

  Future<void> deleteReminder(int id) async {
    await _repo.deleteReminder(id);
    await LocalNotificationService.cancelReminder(id);
  }
}

final reminderManagerProvider = Provider<ReminderManager>((ref) {
  return ReminderManager(ref);
});
