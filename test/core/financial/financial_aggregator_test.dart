import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/core/financial/financial_aggregator.dart';
import 'package:investtrack/features/businesses/models/business.dart';
import 'package:investtrack/features/transactions/models/transaction.dart';

Transaction _tx(TransactionType type, double amount, {DateTime? date}) =>
    Transaction()
      ..businessId = 1
      ..type = type
      ..amount = amount
      ..date = date ?? DateTime(2025, 1, 1);

Business _business({required int id, required String name}) => Business()
  ..id = id
  ..name = name
  ..status = 'Active'
  ..ownershipPercentage = 100
  ..createdDate = DateTime(2025, 1, 1);

void main() {
  group('buildPortfolioSummary', () {
    test('matches TransactionCalculator totals', () {
      final transactions = [
        _tx(TransactionType.investment, 100000),
        _tx(TransactionType.income, 15000),
        _tx(TransactionType.withdrawal, 10000),
      ];

      final summary = buildPortfolioSummary(transactions);

      expect(summary.totalInvested, 100000);
      expect(summary.netProfit, 15000);
      expect(summary.portfolioValue, 105000);
      expect(summary.portfolioRoi, closeTo(15.0, 0.001));
    });
  });

  group('buildMonthlySnapshot', () {
    test('scopes metrics to the given month', () {
      final transactions = [
        _tx(TransactionType.income, 5000, date: DateTime(2025, 3, 5)),
        _tx(TransactionType.expense, 1000, date: DateTime(2025, 3, 20)),
        _tx(TransactionType.income, 9000, date: DateTime(2025, 4, 1)),
      ];

      final snapshot = buildMonthlySnapshot(transactions, DateTime(2025, 3));

      expect(snapshot.income, 5000);
      expect(snapshot.expenses, 1000);
      expect(snapshot.netProfit, 4000);
    });
  });

  group('buildMonthlySnapshots', () {
    test('returns chronologically sorted monthly series', () {
      final transactions = [
        _tx(TransactionType.income, 100, date: DateTime(2025, 2, 1)),
        _tx(TransactionType.income, 200, date: DateTime(2025, 1, 1)),
      ];

      final snapshots = buildMonthlySnapshots(transactions);

      expect(snapshots, hasLength(2));
      expect(snapshots.first.month, DateTime(2025, 1));
      expect(snapshots.last.month, DateTime(2025, 2));
    });
  });

  group('buildBusinessPerformances', () {
    test('ranks businesses by net profit descending', () {
      final businesses = [
        _business(id: 1, name: 'Alpha'),
        _business(id: 2, name: 'Beta'),
      ];
      final transactions = [
        _tx(TransactionType.investment, 1000)..businessId = 1,
        _tx(TransactionType.income, 500)..businessId = 1,
        _tx(TransactionType.investment, 1000)..businessId = 2,
        _tx(TransactionType.income, 2000)..businessId = 2,
      ];

      final rankings = buildBusinessPerformances(businesses, transactions);

      expect(rankings.first.business.name, 'Beta');
      expect(rankings.last.business.name, 'Alpha');
    });
  });

  group('buildRecentTransactions', () {
    test('returns newest transactions first', () {
      final transactions = [
        _tx(TransactionType.income, 1, date: DateTime(2025, 1, 1)),
        _tx(TransactionType.income, 2, date: DateTime(2025, 3, 1)),
        _tx(TransactionType.income, 3, date: DateTime(2025, 2, 1)),
      ];

      final recent = buildRecentTransactions(transactions, limit: 2);

      expect(recent, hasLength(2));
      expect(recent.first.amount, 2);
      expect(recent.last.amount, 3);
    });
  });

  group('analytics chart aggregations', () {
    test('builds cumulative portfolio value and roi series by month', () {
      final transactions = [
        _tx(TransactionType.investment, 1000, date: DateTime(2025, 1, 1)),
        _tx(TransactionType.income, 100, date: DateTime(2025, 2, 1)),
      ];

      final portfolioSeries = buildPortfolioValueSeries(transactions);
      final roiSeries = buildPortfolioRoiSeries(transactions);

      expect(portfolioSeries, hasLength(2));
      expect(portfolioSeries.first.value, 1000);
      expect(portfolioSeries.last.value, 1100);
      expect(roiSeries.last.value, closeTo(10, 0.001));
    });

    test('builds monthly income versus expenses series', () {
      final transactions = [
        _tx(TransactionType.income, 500, date: DateTime(2025, 1, 2)),
        _tx(TransactionType.expense, 100, date: DateTime(2025, 1, 8)),
        _tx(TransactionType.income, 700, date: DateTime(2025, 2, 2)),
      ];

      final series = buildIncomeExpenseSeries(transactions);

      expect(series, hasLength(2));
      expect(series.first.income, 500);
      expect(series.first.expenses, 100);
      expect(series.last.income, 700);
    });

    test('builds allocation and distribution breakdowns', () {
      final businesses = [
        _business(id: 1, name: 'Alpha'),
        _business(id: 2, name: 'Beta'),
      ];
      final transactions = [
        _tx(TransactionType.investment, 1000, date: DateTime(2025, 1, 1))
          ..businessId = 1,
        _tx(
          TransactionType.additionalInvestment,
          500,
          date: DateTime(2025, 1, 2),
        )..businessId = 2,
        _tx(TransactionType.income, 300, date: DateTime(2025, 1, 3))
          ..businessId = 1,
        _tx(TransactionType.expense, 100, date: DateTime(2025, 1, 4))
          ..businessId = 1
          ..category = 'Utilities',
      ];

      final allocation = buildInvestmentAllocation(businesses, transactions);
      final profitContribution = buildProfitContribution(
        businesses,
        transactions,
      );
      final expenseBreakdown = buildExpenseCategoryBreakdown(transactions);
      final txDistribution = buildTransactionTypeDistribution(transactions);

      expect(
        allocation.map((entry) => entry.label),
        containsAll(['Alpha', 'Beta']),
      );
      expect(profitContribution.single.label, 'Alpha');
      expect(expenseBreakdown.single.label, 'Utilities');
      expect(txDistribution.first.value, greaterThan(0));
    });
  });
}
