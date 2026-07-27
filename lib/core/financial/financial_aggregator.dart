import '../../features/businesses/models/business.dart';
import '../../features/dashboard/models/business_performance.dart';
import '../../features/dashboard/models/monthly_snapshot.dart';
import '../../features/dashboard/models/portfolio_summary.dart';
import '../../features/transactions/models/transaction.dart';
import '../../features/transactions/utils/transaction_calculator.dart';
import 'models/analytics_chart_data.dart';
import 'transaction_filters.dart';

/// Builds a [PortfolioSummary] from any transaction slice.
///
/// All values are computed on demand via [TransactionCalculator].
PortfolioSummary buildPortfolioSummary(Iterable<Transaction> transactions) {
  return PortfolioSummary(
    totalInvested: transactions.calculateTotalInvested(),
    totalIncome: transactions.calculateTotalIncome(),
    totalExpenses: transactions.calculateTotalExpenses(),
    totalTaxes: transactions.calculateTotalTaxes(),
    totalWithdrawals: transactions.calculateTotalWithdrawals(),
    netProfit: transactions.calculateNetProfit(),
    netCashFlow: transactions.calculateNetCashFlow(),
    portfolioValue: transactions.calculatePortfolioValue(),
    portfolioRoi: transactions.calculateROI(),
  );
}

/// Builds a [MonthlySnapshot] for the given calendar [month].
MonthlySnapshot buildMonthlySnapshot(
  Iterable<Transaction> transactions,
  DateTime month,
) {
  final monthlyTx = filterByMonth(transactions, month);
  return MonthlySnapshot(
    month: DateTime(month.year, month.month),
    income: monthlyTx.calculateTotalIncome(),
    expenses: monthlyTx.calculateTotalExpenses(),
    netProfit: monthlyTx.calculateNetProfit(),
  );
}

/// Builds one [MonthlySnapshot] per distinct month in [transactions].
///
/// Results are sorted chronologically (oldest first).
/// When [start] and [end] are provided, only months within that range are included.
List<MonthlySnapshot> buildMonthlySnapshots(
  Iterable<Transaction> transactions, {
  DateTime? start,
  DateTime? end,
}) {
  if (transactions.isEmpty) return const [];

  final monthKeys = <String, DateTime>{};
  for (final tx in transactions) {
    final key = '${tx.date.year}-${tx.date.month}';
    monthKeys.putIfAbsent(key, () => DateTime(tx.date.year, tx.date.month));
  }

  var months = monthKeys.values.toList()..sort();

  if (start != null) {
    final rangeStart = DateTime(start.year, start.month);
    months = months.where((m) => !m.isBefore(rangeStart)).toList();
  }
  if (end != null) {
    final rangeEnd = DateTime(end.year, end.month);
    months = months.where((m) => !m.isAfter(rangeEnd)).toList();
  }

  return months
      .map((month) => buildMonthlySnapshot(transactions, month))
      .toList();
}

/// Builds per-business performance rankings from the full ledger.
///
/// When [sortByProfit] is true (default), results are sorted by net profit
/// descending — matching the dashboard ranking order.
List<BusinessPerformance> buildBusinessPerformances(
  List<Business> businesses,
  Iterable<Transaction> transactions, {
  bool sortByProfit = true,
}) {
  final rankings = businesses.map((business) {
    final businessTx = transactions
        .where((t) => t.businessId == business.id)
        .toList();
    return BusinessPerformance(
      business: business,
      invested: businessTx.calculateTotalInvested(),
      netProfit: businessTx.calculateNetProfit(),
      roi: businessTx.calculateROI(),
    );
  }).toList();

  if (sortByProfit) {
    rankings.sort((a, b) => b.netProfit.compareTo(a.netProfit));
  }

  return rankings;
}

/// Returns the [limit] most recent transactions, sorted newest first.
List<Transaction> buildRecentTransactions(
  Iterable<Transaction> transactions, {
  int limit = 10,
}) {
  final sorted = transactions.toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  return sorted.take(limit).toList();
}

/// Builds a cumulative monthly portfolio value series.
List<TimeSeriesPoint> buildPortfolioValueSeries(
  Iterable<Transaction> transactions, {
  DateTime? start,
  DateTime? end,
}) {
  final months = _buildContinuousMonthRange(
    transactions,
    start: start,
    end: end,
  );
  final txList = transactions.toList();

  return months.map((month) {
    final cumulative = txList.where((tx) => !tx.date.isAfter(_monthEnd(month)));
    return TimeSeriesPoint(
      period: month,
      value: buildPortfolioSummary(cumulative).portfolioValue,
    );
  }).toList();
}

/// Builds a cumulative monthly ROI series.
List<TimeSeriesPoint> buildPortfolioRoiSeries(
  Iterable<Transaction> transactions, {
  DateTime? start,
  DateTime? end,
}) {
  final months = _buildContinuousMonthRange(
    transactions,
    start: start,
    end: end,
  );
  final txList = transactions.toList();

  return months.map((month) {
    final cumulative = txList.where((tx) => !tx.date.isAfter(_monthEnd(month)));
    return TimeSeriesPoint(
      period: month,
      value: buildPortfolioSummary(cumulative).portfolioRoi,
    );
  }).toList();
}

/// Builds a monthly income vs expenses comparison series.
List<IncomeExpensePoint> buildIncomeExpenseSeries(
  Iterable<Transaction> transactions, {
  DateTime? start,
  DateTime? end,
}) {
  final months = _buildContinuousMonthRange(
    transactions,
    start: start,
    end: end,
  );

  return months.map((month) {
    final snapshot = buildMonthlySnapshot(transactions, month);
    return IncomeExpensePoint(
      period: month,
      income: snapshot.income,
      expenses: snapshot.expenses,
    );
  }).toList();
}

/// Distribution of invested capital across businesses.
List<BreakdownEntry> buildInvestmentAllocation(
  List<Business> businesses,
  Iterable<Transaction> transactions,
) {
  return buildBusinessPerformances(
        businesses,
        transactions,
        sortByProfit: false,
      )
      .where((performance) => performance.invested > 0)
      .map(
        (performance) => BreakdownEntry(
          label: performance.business.name,
          value: performance.invested,
        ),
      )
      .toList();
}

/// Distribution of positive net profit contribution across businesses.
List<BreakdownEntry> buildProfitContribution(
  List<Business> businesses,
  Iterable<Transaction> transactions,
) {
  return buildBusinessPerformances(
        businesses,
        transactions,
        sortByProfit: false,
      )
      .where((performance) => performance.netProfit > 0)
      .map(
        (performance) => BreakdownEntry(
          label: performance.business.name,
          value: performance.netProfit,
        ),
      )
      .toList();
}

/// Breakdown of expenses and taxes by category label.
List<BreakdownEntry> buildExpenseCategoryBreakdown(
  Iterable<Transaction> transactions,
) {
  final totalsByCategory = <String, double>{};
  for (final tx in transactions) {
    if (tx.type != TransactionType.expense && tx.type != TransactionType.tax) {
      continue;
    }

    final category = (tx.category?.trim().isNotEmpty ?? false)
        ? tx.category!.trim()
        : (tx.type == TransactionType.tax ? 'Tax' : 'Uncategorized');
    totalsByCategory.update(
      category,
      (value) => value + tx.amount,
      ifAbsent: () => tx.amount,
    );
  }

  return totalsByCategory.entries
      .map((entry) => BreakdownEntry(label: entry.key, value: entry.value))
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));
}

/// Distribution of transaction types by record count.
List<BreakdownEntry> buildTransactionTypeDistribution(
  Iterable<Transaction> transactions,
) {
  final counts = <TransactionType, int>{};
  for (final tx in transactions) {
    counts.update(tx.type, (value) => value + 1, ifAbsent: () => 1);
  }

  return counts.entries
      .map(
        (entry) => BreakdownEntry(
          label: _humanizeTransactionType(entry.key),
          value: entry.value.toDouble(),
        ),
      )
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));
}

List<DateTime> _buildContinuousMonthRange(
  Iterable<Transaction> transactions, {
  DateTime? start,
  DateTime? end,
}) {
  final txList = transactions.toList();
  if (txList.isEmpty) return const [];

  final sorted =
      txList.map((tx) => DateTime(tx.date.year, tx.date.month)).toList()
        ..sort();
  final rangeStart = start != null
      ? DateTime(start.year, start.month)
      : sorted.first;
  final rangeEnd = end != null ? DateTime(end.year, end.month) : sorted.last;

  final months = <DateTime>[];
  var cursor = rangeStart;
  while (!cursor.isAfter(rangeEnd)) {
    months.add(cursor);
    cursor = DateTime(cursor.year, cursor.month + 1);
  }
  return months;
}

DateTime _monthEnd(DateTime month) {
  return DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
}

String _humanizeTransactionType(TransactionType type) {
  final raw = type.name;
  final parts = raw.split(RegExp(r'(?<=[a-z])(?=[A-Z])'));
  return parts
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
