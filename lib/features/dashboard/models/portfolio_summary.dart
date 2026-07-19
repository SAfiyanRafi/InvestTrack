/// Ledger-wide financial totals computed from the full transaction history.
///
/// This is a pure-Dart value object — it is never persisted.
/// It is the single source of truth for portfolio-wide metrics and is
/// intentionally reusable by the Dashboard, Reports, Analytics, and Export features.
class PortfolioSummary {
  const PortfolioSummary({
    required this.totalInvested,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalTaxes,
    required this.totalWithdrawals,
    required this.netProfit,
    required this.netCashFlow,
    required this.portfolioValue,
    required this.portfolioRoi,
  });

  /// Total capital injected into all businesses (investments + additional investments).
  final double totalInvested;

  /// Gross income received from all businesses (income + dividends).
  final double totalIncome;

  /// Total operating expenses paid across all businesses.
  final double totalExpenses;

  /// Total taxes paid across all businesses.
  final double totalTaxes;

  /// Total cash withdrawn by the investor from all businesses.
  final double totalWithdrawals;

  /// Net surplus: (Income + Dividends + Asset Sale) − (Expenses + Taxes).
  final double netProfit;

  /// Net cash flow from the investor's perspective across the whole portfolio.
  final double netCashFlow;

  /// Current estimated portfolio value:
  /// Total Invested + Net Profit − Withdrawals − Asset Purchases.
  final double portfolioValue;

  /// Portfolio-wide ROI: (Net Profit / Total Invested) × 100.
  final double portfolioRoi;

  /// Returns true when no financial activity has been recorded yet.
  bool get isEmpty => totalInvested == 0.0 && totalIncome == 0.0;

  /// Returns an empty summary (all zeros).
  static const PortfolioSummary zero = PortfolioSummary(
    totalInvested: 0,
    totalIncome: 0,
    totalExpenses: 0,
    totalTaxes: 0,
    totalWithdrawals: 0,
    netProfit: 0,
    netCashFlow: 0,
    portfolioValue: 0,
    portfolioRoi: 0,
  );
}
