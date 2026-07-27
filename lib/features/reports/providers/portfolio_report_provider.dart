import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/financial/financial_aggregator.dart';
import '../../../core/financial/models/filtered_ledger.dart';
import '../../../core/financial/providers/report_filter_provider.dart';
import '../../dashboard/models/business_performance.dart';
import '../../dashboard/models/monthly_snapshot.dart';
import '../../dashboard/models/portfolio_summary.dart';

class PortfolioReportData {
  const PortfolioReportData({
    required this.summary,
    required this.monthlySnapshots,
    required this.businessPerformances,
    required this.filteredLedger,
  });

  final PortfolioSummary summary;
  final List<MonthlySnapshot> monthlySnapshots;
  final List<BusinessPerformance> businessPerformances;
  final FilteredLedger filteredLedger;

  bool get isEmpty => filteredLedger.transactions.isEmpty;

  int get transactionCount => filteredLedger.transactions.length;

  int get businessCount => filteredLedger.businesses.length;
}

final portfolioReportProvider = Provider<AsyncValue<PortfolioReportData>>((
  ref,
) {
  final filteredLedgerAsync = ref.watch(reportFilteredLedgerProvider);

  return filteredLedgerAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    data: (ledger) {
      final summary = buildPortfolioSummary(ledger.transactions);
      final monthlySnapshots = buildMonthlySnapshots(ledger.transactions);
      final businessPerformances = buildBusinessPerformances(
        ledger.businesses,
        ledger.transactions,
      );

      return AsyncValue.data(
        PortfolioReportData(
          summary: summary,
          monthlySnapshots: monthlySnapshots,
          businessPerformances: businessPerformances,
          filteredLedger: ledger,
        ),
      );
    },
  );
});
