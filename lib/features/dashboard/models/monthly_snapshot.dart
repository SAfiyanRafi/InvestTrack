/// A financial snapshot for a configurable calendar month.
///
/// Pure-Dart value object — never persisted.
/// Designed to support date-range customisation in future phases (Reports, Analytics).
class MonthlySnapshot {
  const MonthlySnapshot({
    required this.month,
    required this.income,
    required this.expenses,
    required this.netProfit,
  });

  /// The calendar month this snapshot covers (only year + month are significant).
  final DateTime month;

  /// Gross income received within [month] (income + dividends).
  final double income;

  /// Total expenses paid within [month].
  final double expenses;

  /// Net profit within [month]:
  /// (Income + Dividends + Asset Sale) − (Expenses + Taxes).
  final double netProfit;

  /// Returns an empty snapshot for [month] (all values zero).
  factory MonthlySnapshot.empty(DateTime month) =>
      MonthlySnapshot(month: month, income: 0, expenses: 0, netProfit: 0);
}
