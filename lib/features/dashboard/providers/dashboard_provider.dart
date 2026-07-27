import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/financial/financial_aggregator.dart';
import '../../businesses/models/business.dart';
import '../../businesses/providers/business_provider.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../models/dashboard_data.dart';

/// Assembles a [DashboardData] object by watching the existing streams from
/// Phase 3 and delegating all financial calculations to the shared financial
/// layer ([financial_aggregator.dart] + [TransactionCalculator]).
///
/// Uses proper [AsyncValue.when] chaining so that loading/error states from
/// either stream propagate correctly to the UI without unsafe type casts.
///
/// This provider contains **zero financial logic of its own** — it is purely
/// an aggregation layer that maps raw ledger data into the dashboard model.
final dashboardProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final businessesAsync = ref.watch(watchBusinessesProvider);
  final transactionsAsync = ref.watch(watchTransactionsProvider);

  return businessesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (businesses) => transactionsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
      data: (transactions) =>
          AsyncValue.data(_buildDashboardData(businesses, transactions)),
    ),
  );
});

/// Pure function — builds [DashboardData] from raw database lists.
/// Delegates all metric computation to [financial_aggregator.dart].
DashboardData _buildDashboardData(
  List<Business> businesses,
  List<Transaction> transactions,
) {
  final summary = buildPortfolioSummary(transactions);
  final monthlySnapshot = buildMonthlySnapshot(transactions, DateTime.now());
  final rankings = buildBusinessPerformances(businesses, transactions);
  final recentTransactions = buildRecentTransactions(transactions);
  final activeBusinessCount = businesses
      .where((b) => b.status == 'Active')
      .length;

  return DashboardData(
    summary: summary,
    monthlySnapshot: monthlySnapshot,
    businessRankings: rankings,
    recentTransactions: recentTransactions,
    activeBusinessCount: activeBusinessCount,
    totalBusinessCount: businesses.length,
  );
}
