import '../models/reminder.dart';

abstract class ReminderRepository {
  Stream<List<Reminder>> watchReminders();

  Future<List<Reminder>> getAllReminders();

  Future<Reminder?> getReminderById(int id);

  Future<void> saveReminder(Reminder reminder);

  Future<void> deleteReminder(int id);
}
