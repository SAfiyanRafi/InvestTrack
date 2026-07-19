import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/analytics/providers/analytics_provider.dart';
import '../../features/businesses/providers/business_provider.dart';
import '../../features/dashboard/providers/dashboard_provider.dart';
import '../../features/documents/providers/document_provider.dart';
import '../../features/notifications/providers/notification_provider.dart';
import '../../features/notifications/providers/reminder_provider.dart';
import '../../features/reports/providers/portfolio_report_provider.dart';
import '../../features/transactions/providers/transaction_provider.dart';

/// Warms up commonly-used providers so first navigation feels instant.
final appStartupWarmupProvider = FutureProvider<void>((ref) async {
  // Construct repositories early.
  ref.read(businessRepositoryProvider);
  ref.read(transactionRepositoryProvider);

  try {
    // Prime initial database streams used by all major tabs.
    await Future.wait([
      ref.read(watchBusinessesProvider.future),
      ref.read(watchTransactionsProvider.future),
    ]);
  } catch (_) {
    // Warmup failures should not block app launch.
  }

  // Prime derived providers used by initial tab navigations.
  ref.read(filteredBusinessesProvider);
  ref.read(filteredTransactionsProvider);
  ref.read(dashboardProvider);
  ref.read(analyticsProvider);
  ref.read(portfolioReportProvider);
  ref.read(documentRepositoryProvider);
  ref.read(filteredDocumentAttachmentsProvider);
  ref.read(notificationRepositoryProvider);
  ref.read(reminderRepositoryProvider);
  ref.read(unreadNotificationsCountProvider);
  ref.read(recentNotificationsProvider);
  ref.read(upcomingReminderProvider);
  ref.read(reminderScheduleSyncProvider);
  ref.read(reminderDueSyncProvider);
});
