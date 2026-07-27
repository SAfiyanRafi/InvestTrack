import '../../../features/transactions/models/transaction.dart';
import 'portfolio_summary.dart';
import 'monthly_snapshot.dart';
import 'business_performance.dart';

/// UI-only aggregation object produced by [dashboardProvider].
///
/// This model exists solely to carry pre-assembled presentation data to the
/// Dashboard screen. It contains **no calculations** — all values are
/// populated by the provider using the Phase 3 financial engine.
class DashboardData {
  const DashboardData({
    required this.summary,
    required this.monthlySnapshot,
    required this.businessRankings,
    required this.recentTransactions,
    required this.activeBusinessCount,
    required this.totalBusinessCount,
  });

  /// Ledger-wide portfolio financial totals.
  final PortfolioSummary summary;

  /// Financial snapshot for the current calendar month.
  final MonthlySnapshot monthlySnapshot;

  /// All businesses ranked by net profit (descending).
  final List<BusinessPerformance> businessRankings;

  /// The most recent 10 transactions across all businesses.
  final List<Transaction> recentTransactions;

  /// Count of businesses with status == 'Active'.
  final int activeBusinessCount;

  /// Total count of all businesses (active + archived).
  final int totalBusinessCount;

  /// Returns true when no businesses or transactions have been recorded.
  bool get hasNoData => totalBusinessCount == 0 && recentTransactions.isEmpty;

  /// An empty dashboard — shown on first launch before any data is entered.
  static final DashboardData empty = DashboardData(
    summary: PortfolioSummary.zero,
    monthlySnapshot: MonthlySnapshot.empty(DateTime.now()),
    businessRankings: const [],
    recentTransactions: const [],
    activeBusinessCount: 0,
    totalBusinessCount: 0,
  );
}
