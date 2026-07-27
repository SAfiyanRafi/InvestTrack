import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/database/isar_database.dart';
import '../../core/services/local_notification_service.dart';
import '../../features/analytics/providers/analytics_provider.dart';
import '../../features/businesses/providers/business_provider.dart';
import '../../features/dashboard/providers/dashboard_provider.dart';
import '../../features/documents/providers/document_provider.dart';
import '../../features/notifications/providers/notification_provider.dart';
import '../../features/notifications/providers/reminder_provider.dart';
import '../../features/reports/providers/portfolio_report_provider.dart';
import '../../features/transactions/providers/transaction_provider.dart';

/// Describes the outcome of the app's initial bootstrap step.
class AppStartupResult {
  const AppStartupResult._({
    required this.initialized,
    this.database,
    this.error,
    this.stackTrace,
  });

  factory AppStartupResult.ready(Object? database) {
    return AppStartupResult._(initialized: true, database: database);
  }

  factory AppStartupResult.failed(Object error, [StackTrace? stackTrace]) {
    return AppStartupResult._(
      initialized: false,
      error: error,
      stackTrace: stackTrace,
    );
  }

  final bool initialized;
  final Object? database;
  final Object? error;
  final StackTrace? stackTrace;

  Isar? get isar => database is Isar ? database as Isar : null;
}

Future<AppStartupResult> initializeAppStartup() async {
  try {
    final isar = await IsarDatabase.init();

    try {
      await LocalNotificationService.initialize();
    } catch (_) {
      // Notifications are optional for startup; continue with app launch.
    }

    return AppStartupResult.ready(isar);
  } catch (error, stackTrace) {
    return AppStartupResult.failed(error, stackTrace);
  }
}

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
