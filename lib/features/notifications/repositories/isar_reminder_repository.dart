import 'package:isar/isar.dart';

import '../models/reminder.dart';
import 'reminder_repository.dart';

class IsarReminderRepository implements ReminderRepository {
  const IsarReminderRepository(this._isar);

  final Isar _isar;

  @override
  Stream<List<Reminder>> watchReminders() {
    return _isar.reminders.where().watch(fireImmediately: true);
  }

  @override
  Future<List<Reminder>> getAllReminders() {
    return _isar.reminders.where().findAll();
  }

  @override
  Future<Reminder?> getReminderById(int id) {
    return _isar.reminders.get(id);
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    await _isar.writeTxn(() async {
      await _isar.reminders.put(reminder);
    });
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _isar.writeTxn(() async {
      await _isar.reminders.delete(id);
    });
  }
}
