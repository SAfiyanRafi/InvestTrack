import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/financial/financial_aggregator.dart';
import '../../../core/financial/models/analytics_chart_data.dart';
import '../../../core/financial/providers/report_filter_provider.dart';
import '../../dashboard/models/business_performance.dart';
import '../../dashboard/models/monthly_snapshot.dart';
import '../../dashboard/models/portfolio_summary.dart';

class AnalyticsData {
  const AnalyticsData({
    required this.summary,
    required this.monthlySnapshots,
    required this.businessComparisons,
    required this.bestPerformer,
    required this.worstPerformer,
    required this.portfolioGrowthSeries,
    required this.roiTrendSeries,
    required this.incomeExpenseSeries,
    required this.investmentAllocation,
    required this.profitContribution,
    required this.expenseCategories,
    required this.transactionDistribution,
  });

  final PortfolioSummary summary;
  final List<MonthlySnapshot> monthlySnapshots;
  final List<BusinessPerformance> businessComparisons;
  final BusinessPerformance? bestPerformer;
  final BusinessPerformance? worstPerformer;
  final List<TimeSeriesPoint> portfolioGrowthSeries;
  final List<TimeSeriesPoint> roiTrendSeries;
  final List<IncomeExpensePoint> incomeExpenseSeries;
  final List<BreakdownEntry> investmentAllocation;
  final List<BreakdownEntry> profitContribution;
  final List<BreakdownEntry> expenseCategories;
  final List<BreakdownEntry> transactionDistribution;

  bool get hasTransactionData =>
      portfolioGrowthSeries.isNotEmpty ||
      roiTrendSeries.isNotEmpty ||
      incomeExpenseSeries.isNotEmpty ||
      investmentAllocation.isNotEmpty ||
      profitContribution.isNotEmpty ||
      expenseCategories.isNotEmpty ||
      transactionDistribution.isNotEmpty;
}

final analyticsProvider = Provider<AsyncValue<AnalyticsData>>((ref) {
  final filteredLedgerAsync = ref.watch(analyticsFilteredLedgerProvider);

  return filteredLedgerAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    data: (ledger) {
      final (start, end) = ledger.filter.resolveDateRange();
      final comparisons = buildBusinessPerformances(
        ledger.businesses,
        ledger.transactions,
      );

      return AsyncValue.data(
        AnalyticsData(
          summary: buildPortfolioSummary(ledger.transactions),
          monthlySnapshots: buildMonthlySnapshots(ledger.transactions),
          businessComparisons: comparisons,
          bestPerformer: comparisons.isEmpty ? null : comparisons.first,
          worstPerformer: comparisons.isEmpty ? null : comparisons.last,
          portfolioGrowthSeries: buildPortfolioValueSeries(
            ledger.transactions,
            start: start,
            end: end,
          ),
          roiTrendSeries: buildPortfolioRoiSeries(
            ledger.transactions,
            start: start,
            end: end,
          ),
          incomeExpenseSeries: buildIncomeExpenseSeries(
            ledger.transactions,
            start: start,
            end: end,
          ),
          investmentAllocation: buildInvestmentAllocation(
            ledger.businesses,
            ledger.transactions,
          ),
          profitContribution: buildProfitContribution(
            ledger.businesses,
            ledger.transactions,
          ),
          expenseCategories: buildExpenseCategoryBreakdown(ledger.transactions),
          transactionDistribution: buildTransactionTypeDistribution(
            ledger.transactions,
          ),
        ),
      );
    },
  );
});
