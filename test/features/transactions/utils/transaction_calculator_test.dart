import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/features/transactions/models/transaction.dart';
import 'package:investtrack/features/transactions/utils/transaction_calculator.dart';

// ── Test helpers ──────────────────────────────────────────────────────────────

/// Creates a [Transaction] with the given [type] and [amount].
///
/// All other fields are set to safe defaults so the calculator extension methods
/// (which only access `type` and `amount`) work without a live Isar database.
Transaction _tx(TransactionType type, double amount) => Transaction()
  ..businessId = 1
  ..type = type
  ..amount = amount
  ..date = DateTime(2025, 1, 1)
  ..tags = [];

void main() {
  // ── Main scenario ───────────────────────────────────────────────────────────

  group('Main scenario — Investment + Income + Withdrawal', () {
    // Investment: 150,000  Income: 15,000  Withdrawal: 100,000
    final transactions = [
      _tx(TransactionType.investment, 150000),
      _tx(TransactionType.income, 15000),
      _tx(TransactionType.withdrawal, 100000),
    ];

    test('Total Invested = 150,000', () {
      expect(transactions.calculateTotalInvested(), 150000.0);
    });

    test('Net Profit = 15,000', () {
      expect(transactions.calculateNetProfit(), 15000.0);
    });

    test('ROI = 10%', () {
      expect(transactions.calculateROI(), closeTo(10.0, 0.001));
    });

    test('Net Cash Flow = -235,000', () {
      // Inflows:  Income 15,000
      // Outflows: Investment 150,000 + Withdrawal 100,000 = 250,000
      // Net:      15,000 - 250,000 = -235,000
      expect(transactions.calculateNetCashFlow(), -235000.0);
    });

    test('Portfolio Value = 65,000', () {
      // Total Invested 150,000 + Net Profit 15,000 - Withdrawal 100,000 = 65,000
      expect(transactions.calculatePortfolioValue(), 65000.0);
    });
  });

  // ── Individual transaction type isolation tests ──────────────────────────────

  group('Investment', () {
    final tx = [_tx(TransactionType.investment, 50000)];

    test('increases Total Invested', () {
      expect(tx.calculateTotalInvested(), 50000.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash outflow (negative Cash Flow)', () {
      expect(tx.calculateNetCashFlow(), -50000.0);
    });
    test('increases Portfolio Value (capital deployed)', () {
      expect(tx.calculatePortfolioValue(), 50000.0);
    });
  });

  group('Additional Investment', () {
    final tx = [_tx(TransactionType.additionalInvestment, 20000)];

    test('increases Total Invested', () {
      expect(tx.calculateTotalInvested(), 20000.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash outflow', () {
      expect(tx.calculateNetCashFlow(), -20000.0);
    });
    test('increases Portfolio Value', () {
      expect(tx.calculatePortfolioValue(), 20000.0);
    });
  });

  group('Income', () {
    final tx = [_tx(TransactionType.income, 8000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('increases Net Profit', () {
      expect(tx.calculateNetProfit(), 8000.0);
    });
    test('is a cash inflow', () {
      expect(tx.calculateNetCashFlow(), 8000.0);
    });
    test('increases Portfolio Value via profit', () {
      // Invested 0 + Profit 8000 - 0 = 8000
      expect(tx.calculatePortfolioValue(), 8000.0);
    });
  });

  group('Dividend', () {
    final tx = [_tx(TransactionType.dividend, 5000)];

    test('increases Net Profit', () {
      expect(tx.calculateNetProfit(), 5000.0);
    });
    test('is a cash inflow', () {
      expect(tx.calculateNetCashFlow(), 5000.0);
    });
  });

  group('Expense', () {
    final tx = [_tx(TransactionType.expense, 3000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('reduces Net Profit', () {
      expect(tx.calculateNetProfit(), -3000.0);
    });
    test('is a cash outflow', () {
      expect(tx.calculateNetCashFlow(), -3000.0);
    });
  });

  group('Tax', () {
    final tx = [_tx(TransactionType.tax, 1500)];

    test('reduces Net Profit', () {
      expect(tx.calculateNetProfit(), -1500.0);
    });
    test('is a cash outflow', () {
      expect(tx.calculateNetCashFlow(), -1500.0);
    });
  });

  group('Withdrawal', () {
    final tx = [_tx(TransactionType.withdrawal, 40000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash OUTFLOW (corrected)', () {
      // Previously incorrectly classified as inflow.
      expect(tx.calculateNetCashFlow(), -40000.0);
    });
    test('reduces Portfolio Value', () {
      // Invested 0 + Profit 0 - Withdrawal 40,000 = -40,000
      expect(tx.calculatePortfolioValue(), -40000.0);
    });
    test('ROI is 0 when no capital invested', () {
      expect(tx.calculateROI(), 0.0);
    });
  });

  group('Loan', () {
    final tx = [_tx(TransactionType.loan, 25000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash INFLOW (corrected)', () {
      // Previously incorrectly classified as outflow.
      expect(tx.calculateNetCashFlow(), 25000.0);
    });
    test('does NOT affect Portfolio Value directly', () {
      expect(tx.calculatePortfolioValue(), 0.0);
    });
  });

  group('Loan Repayment', () {
    final tx = [_tx(TransactionType.loanRepayment, 10000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash OUTFLOW (corrected)', () {
      // Previously incorrectly classified as inflow.
      expect(tx.calculateNetCashFlow(), -10000.0);
    });
  });

  group('Asset Purchase', () {
    final tx = [_tx(TransactionType.assetPurchase, 12000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('is a cash outflow', () {
      expect(tx.calculateNetCashFlow(), -12000.0);
    });
    test('reduces Portfolio Value', () {
      expect(tx.calculatePortfolioValue(), -12000.0);
    });
  });

  group('Asset Sale', () {
    final tx = [_tx(TransactionType.assetSale, 18000)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('INCREASES Net Profit (corrected — now included)', () {
      // Asset Sale proceeds count as revenue in the profit formula.
      expect(tx.calculateNetProfit(), 18000.0);
    });
    test('is a cash inflow', () {
      expect(tx.calculateNetCashFlow(), 18000.0);
    });
    test('increases Portfolio Value via profit', () {
      expect(tx.calculatePortfolioValue(), 18000.0);
    });
  });

  group('Other', () {
    final tx = [_tx(TransactionType.other, 9999)];

    test('does NOT affect Total Invested', () {
      expect(tx.calculateTotalInvested(), 0.0);
    });
    test('does NOT affect Net Profit', () {
      expect(tx.calculateNetProfit(), 0.0);
    });
    test('does NOT affect Cash Flow', () {
      expect(tx.calculateNetCashFlow(), 0.0);
    });
    test('does NOT affect Portfolio Value', () {
      expect(tx.calculatePortfolioValue(), 0.0);
    });
  });

  // ── ROI edge cases ───────────────────────────────────────────────────────────

  group('ROI', () {
    test('returns 0.0 when no investment exists', () {
      final tx = [_tx(TransactionType.income, 5000)];
      expect(tx.calculateROI(), 0.0);
    });

    test('returns 0.0 for an empty list', () {
      expect(<Transaction>[].calculateROI(), 0.0);
    });

    test('calculates correctly with profit and loss mix', () {
      // Invested 100,000; Income 20,000 - Expense 5,000 = Net Profit 15,000
      // ROI = 15,000 / 100,000 * 100 = 15%
      final tx = [
        _tx(TransactionType.investment, 100000),
        _tx(TransactionType.income, 20000),
        _tx(TransactionType.expense, 5000),
      ];
      expect(tx.calculateROI(), closeTo(15.0, 0.001));
    });

    test('returns negative ROI when expenses exceed income', () {
      final tx = [
        _tx(TransactionType.investment, 50000),
        _tx(TransactionType.expense, 10000),
      ];
      expect(tx.calculateROI(), closeTo(-20.0, 0.001));
    });
  });

  // ── Portfolio Value composite test ───────────────────────────────────────────

  group('Portfolio Value — complex composite', () {
    test('combines all factors correctly', () {
      // Investment:       200,000
      // Income:            30,000
      // Dividend:          10,000
      // Expense:          -12,000
      // Tax:               -3,000
      // Asset Sale:        50,000
      // Withdrawal:       -80,000  (reduces portfolio)
      // Asset Purchase:   -25,000  (reduces portfolio)
      //
      // Net Profit = (30,000 + 10,000 + 50,000) - (12,000 + 3,000) = 75,000
      // Portfolio Value = 200,000 + 75,000 - 80,000 - 25,000 = 170,000

      final tx = [
        _tx(TransactionType.investment, 200000),
        _tx(TransactionType.income, 30000),
        _tx(TransactionType.dividend, 10000),
        _tx(TransactionType.expense, 12000),
        _tx(TransactionType.tax, 3000),
        _tx(TransactionType.assetSale, 50000),
        _tx(TransactionType.withdrawal, 80000),
        _tx(TransactionType.assetPurchase, 25000),
      ];

      expect(tx.calculateTotalInvested(), 200000.0);
      expect(tx.calculateNetProfit(), 75000.0);
      expect(tx.calculateROI(), closeTo(37.5, 0.001));
      expect(tx.calculatePortfolioValue(), 170000.0);
    });
  });

  // ── TransactionTypeClassifier extension tests ────────────────────────────────

  group('TransactionTypeClassifier helpers', () {
    test('isRevenueType covers Income, Dividend, AssetSale', () {
      expect(TransactionType.income.isRevenueType, isTrue);
      expect(TransactionType.dividend.isRevenueType, isTrue);
      expect(TransactionType.assetSale.isRevenueType, isTrue);
      expect(TransactionType.investment.isRevenueType, isFalse);
      expect(TransactionType.withdrawal.isRevenueType, isFalse);
    });

    test('isCostType covers Expense and Tax only', () {
      expect(TransactionType.expense.isCostType, isTrue);
      expect(TransactionType.tax.isCostType, isTrue);
      expect(TransactionType.withdrawal.isCostType, isFalse);
      expect(TransactionType.loanRepayment.isCostType, isFalse);
    });

    test('isInvestmentType covers Investment and AdditionalInvestment', () {
      expect(TransactionType.investment.isInvestmentType, isTrue);
      expect(TransactionType.additionalInvestment.isInvestmentType, isTrue);
      expect(TransactionType.income.isInvestmentType, isFalse);
    });

    test('isWithdrawalType covers only Withdrawal', () {
      expect(TransactionType.withdrawal.isWithdrawalType, isTrue);
      expect(TransactionType.investment.isWithdrawalType, isFalse);
      expect(TransactionType.expense.isWithdrawalType, isFalse);
    });

    test('affectsProfit is true only for revenue and cost types', () {
      expect(TransactionType.income.affectsProfit, isTrue);
      expect(TransactionType.dividend.affectsProfit, isTrue);
      expect(TransactionType.assetSale.affectsProfit, isTrue);
      expect(TransactionType.expense.affectsProfit, isTrue);
      expect(TransactionType.tax.affectsProfit, isTrue);
      expect(TransactionType.investment.affectsProfit, isFalse);
      expect(TransactionType.withdrawal.affectsProfit, isFalse);
      expect(TransactionType.loan.affectsProfit, isFalse);
      expect(TransactionType.loanRepayment.affectsProfit, isFalse);
    });

    test('affectsCashFlow is false only for Other', () {
      expect(TransactionType.other.affectsCashFlow, isFalse);
      for (final t in TransactionType.values) {
        if (t != TransactionType.other) {
          expect(
            t.affectsCashFlow,
            isTrue,
            reason: '$t should affect cash flow',
          );
        }
      }
    });
  });

  // ── Empty list edge cases ────────────────────────────────────────────────────

  group('Empty transaction list', () {
    const empty = <Transaction>[];

    test(
      'Total Invested = 0',
      () => expect(empty.calculateTotalInvested(), 0.0),
    );
    test('Net Profit = 0', () => expect(empty.calculateNetProfit(), 0.0));
    test('Net Cash Flow = 0', () => expect(empty.calculateNetCashFlow(), 0.0));
    test('ROI = 0', () => expect(empty.calculateROI(), 0.0));
    test(
      'Portfolio Value = 0',
      () => expect(empty.calculatePortfolioValue(), 0.0),
    );
  });
}
