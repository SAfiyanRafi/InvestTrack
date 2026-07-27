import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_notification_service.dart';
import '../../documents/models/document_attachment.dart';
import '../../transactions/models/transaction.dart';
import '../models/app_notification.dart';
import '../models/reminder.dart';
import '../repositories/notification_repository.dart';
import '../repositories/reminder_repository.dart';
import 'notification_provider.dart';
import 'reminder_provider.dart';

class NotificationEventEngine {
  const NotificationEventEngine(this._ref);

  final Ref _ref;

  NotificationRepository get _notificationRepo =>
      _ref.read(notificationRepositoryProvider);
  ReminderRepository get _reminderRepo => _ref.read(reminderRepositoryProvider);

  Future<void> emitBusinessCreated({
    required int businessId,
    required String businessName,
  }) async {
    await _emit(
      title: 'Business created',
      body: '$businessName was added to your portfolio.',
      category: NotificationCategory.business,
      type: NotificationType.success,
      relatedBusinessId: businessId,
      actionRoute: '/businesses/$businessId',
    );
  }

  Future<void> emitBusinessArchived({
    required int businessId,
    required String businessName,
    required bool archived,
  }) async {
    await _emit(
      title: archived ? 'Business archived' : 'Business restored',
      body:
          '$businessName status changed to ${archived ? 'Archived' : 'Active'}.',
      category: NotificationCategory.business,
      type: NotificationType.informational,
      relatedBusinessId: businessId,
      actionRoute: '/businesses/$businessId',
    );
  }

  Future<void> emitBusinessDeleted(String businessName) async {
    await _emit(
      title: 'Business deleted',
      body: '$businessName was removed from your portfolio.',
      category: NotificationCategory.business,
      type: NotificationType.warning,
    );
  }

  Future<void> emitTransactionEvent({required Transaction transaction}) async {
    final event = _transactionEventMeta(transaction.type);
    await _emit(
      title: event.title,
      body: event.body,
      category: NotificationCategory.financial,
      type: event.type,
      relatedBusinessId: transaction.businessId,
      relatedTransactionId: transaction.id,
      actionRoute: '/transactions/${transaction.id}/edit',
    );
  }

  Future<void> emitDocumentAdded({
    required AttachmentOwnerType ownerType,
    required int ownerId,
    required int count,
  }) async {
    await _emit(
      title: 'Document added',
      body: count == 1 ? '1 attachment added.' : '$count attachments added.',
      category: NotificationCategory.documents,
      type: NotificationType.success,
      relatedBusinessId: ownerType == AttachmentOwnerType.business
          ? ownerId
          : null,
      relatedTransactionId: ownerType == AttachmentOwnerType.transaction
          ? ownerId
          : null,
      actionRoute: '/settings/documents',
    );
  }

  Future<void> emitDocumentUpdated(String documentName) async {
    await _emit(
      title: 'Document updated',
      body: '$documentName was renamed.',
      category: NotificationCategory.documents,
      type: NotificationType.informational,
      actionRoute: '/settings/documents',
    );
  }

  Future<void> emitDocumentDeleted(String documentName) async {
    await _emit(
      title: 'Document deleted',
      body: '$documentName was removed.',
      category: NotificationCategory.documents,
      type: NotificationType.warning,
      actionRoute: '/settings/documents',
    );
  }

  Future<void> suggestBusinessReview({
    required int businessId,
    required String businessName,
  }) async {
    await _emit(
      title: 'Reminder suggestion',
      body: 'Review $businessName performance in 30 days?',
      category: NotificationCategory.reminder,
      type: NotificationType.informational,
      relatedBusinessId: businessId,
      actionRoute:
          '/reminders/new?businessId=$businessId&category=businessReview',
    );

    final now = DateTime.now();
    final reminder = Reminder()
      ..title = 'Review $businessName performance'
      ..description = 'Auto-suggested after business creation.'
      ..dueDate = now.add(const Duration(days: 30))
      ..repeat = ReminderRepeat.none
      ..priority = ReminderPriority.medium
      ..category = ReminderCategory.businessReview
      ..businessId = businessId
      ..createdAt = now
      ..updatedAt = now;

    await _reminderRepo.saveReminder(reminder);
  }

  Future<void> suggestRoiReview({required int businessId}) async {
    await _emit(
      title: 'Reminder suggestion',
      body: 'Schedule an ROI review for your new investment?',
      category: NotificationCategory.reminder,
      type: NotificationType.informational,
      relatedBusinessId: businessId,
      actionRoute:
          '/reminders/new?businessId=$businessId&category=investmentReview',
    );
  }

  Future<void> suggestDocumentExpiry({
    required AttachmentOwnerType ownerType,
    required int ownerId,
  }) async {
    final route = ownerType == AttachmentOwnerType.business
        ? '/reminders/new?businessId=$ownerId&category=documentExpiry'
        : '/reminders/new?transactionId=$ownerId&category=documentExpiry';

    await _emit(
      title: 'Reminder suggestion',
      body: 'Set an expiration reminder for the new document?',
      category: NotificationCategory.reminder,
      type: NotificationType.informational,
      actionRoute: route,
    );
  }

  Future<void> _emit({
    required String title,
    required String body,
    required NotificationCategory category,
    required NotificationType type,
    int? relatedBusinessId,
    int? relatedTransactionId,
    String? actionRoute,
  }) async {
    final notification = AppNotification()
      ..title = title
      ..body = body
      ..timestamp = DateTime.now()
      ..category = category
      ..type = type
      ..relatedBusinessId = relatedBusinessId
      ..relatedTransactionId = relatedTransactionId
      ..actionRoute = actionRoute;

    await _notificationRepo.saveNotification(notification);
    await LocalNotificationService.showNotification(
      notificationId: notification.id == 0
          ? DateTime.now().millisecondsSinceEpoch.remainder(10000)
          : notification.id,
      title: title,
      body: body,
    );
  }
}

final notificationEventEngineProvider = Provider<NotificationEventEngine>((
  ref,
) {
  return NotificationEventEngine(ref);
});

class _TransactionEventMeta {
  const _TransactionEventMeta(this.title, this.body, this.type);

  final String title;
  final String body;
  final NotificationType type;
}

_TransactionEventMeta _transactionEventMeta(TransactionType type) {
  switch (type) {
    case TransactionType.investment:
      return const _TransactionEventMeta(
        'Investment added',
        'A new investment was recorded.',
        NotificationType.success,
      );
    case TransactionType.additionalInvestment:
      return const _TransactionEventMeta(
        'Additional investment added',
        'Capital injection recorded successfully.',
        NotificationType.success,
      );
    case TransactionType.income:
      return const _TransactionEventMeta(
        'Income received',
        'A new income transaction was recorded.',
        NotificationType.success,
      );
    case TransactionType.dividend:
      return const _TransactionEventMeta(
        'Dividend received',
        'A dividend payout was recorded.',
        NotificationType.success,
      );
    case TransactionType.expense:
      return const _TransactionEventMeta(
        'Expense recorded',
        'A new expense transaction was recorded.',
        NotificationType.warning,
      );
    case TransactionType.withdrawal:
      return const _TransactionEventMeta(
        'Withdrawal recorded',
        'A capital withdrawal was recorded.',
        NotificationType.warning,
      );
    case TransactionType.loan:
      return const _TransactionEventMeta(
        'Loan created',
        'A loan entry was added to the ledger.',
        NotificationType.warning,
      );
    case TransactionType.loanRepayment:
      return const _TransactionEventMeta(
        'Loan repaid',
        'A loan repayment was recorded.',
        NotificationType.success,
      );
    case TransactionType.assetPurchase:
      return const _TransactionEventMeta(
        'Asset purchase recorded',
        'A new asset purchase was recorded.',
        NotificationType.warning,
      );
    case TransactionType.assetSale:
      return const _TransactionEventMeta(
        'Asset sale recorded',
        'An asset sale transaction was recorded.',
        NotificationType.success,
      );
    case TransactionType.tax:
      return const _TransactionEventMeta(
        'Tax recorded',
        'A tax transaction was recorded.',
        NotificationType.warning,
      );
    case TransactionType.other:
      return const _TransactionEventMeta(
        'Transaction added',
        'A new ledger transaction was recorded.',
        NotificationType.informational,
      );
  }
}
