class TimeSeriesPoint {
  const TimeSeriesPoint({
    required this.period,
    required this.value,
  });

  final DateTime period;
  final double value;
}

class IncomeExpensePoint {
  const IncomeExpensePoint({
    required this.period,
    required this.income,
    required this.expenses,
  });

  final DateTime period;
  final double income;
  final double expenses;
}

class BreakdownEntry {
  const BreakdownEntry({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}