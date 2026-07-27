import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/core/financial/models/report_filter.dart';
import 'package:investtrack/core/financial/transaction_filters.dart';
import 'package:investtrack/features/transactions/models/transaction.dart';

Transaction _tx({
  required TransactionType type,
  required double amount,
  required DateTime date,
  int businessId = 1,
  String? category,
  List<String> tags = const [],
  String? description,
}) => Transaction()
  ..businessId = businessId
  ..type = type
  ..amount = amount
  ..date = date
  ..category = category
  ..tags = tags
  ..description = description;

void main() {
  group('filterByMonth', () {
    final transactions = [
      _tx(
        type: TransactionType.income,
        amount: 100,
        date: DateTime(2025, 3, 15),
      ),
      _tx(
        type: TransactionType.expense,
        amount: 50,
        date: DateTime(2025, 4, 1),
      ),
    ];

    test('returns only transactions in the target month', () {
      final result = filterByMonth(transactions, DateTime(2025, 3));
      expect(result, hasLength(1));
      expect(result.first.amount, 100);
    });
  });

  group('filterByDateRange', () {
    final transactions = [
      _tx(type: TransactionType.income, amount: 10, date: DateTime(2025, 1, 1)),
      _tx(
        type: TransactionType.income,
        amount: 20,
        date: DateTime(2025, 1, 31),
      ),
      _tx(type: TransactionType.income, amount: 30, date: DateTime(2025, 2, 1)),
    ];

    test('includes boundary dates', () {
      final result = filterByDateRange(
        transactions,
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      expect(result, hasLength(2));
      expect(result.fold<double>(0, (sum, t) => sum + t.amount), 30);
    });
  });

  group('ReportFilter.resolveDateRange', () {
    test('month preset covers full calendar month', () {
      final filter = ReportFilter(
        period: ReportPeriod.month,
        referenceDate: DateTime(2025, 6, 15),
      );
      final (start, end) = filter.resolveDateRange();
      expect(start, DateTime(2025, 6, 1));
      expect(end, DateTime(2025, 6, 30, 23, 59, 59, 999));
    });

    test('quarter preset covers Q2', () {
      final filter = ReportFilter(
        period: ReportPeriod.quarter,
        referenceDate: DateTime(2025, 5, 10),
      );
      final (start, end) = filter.resolveDateRange();
      expect(start, DateTime(2025, 4, 1));
      expect(end, DateTime(2025, 6, 30, 23, 59, 59, 999));
    });

    test('year preset covers full calendar year', () {
      final filter = ReportFilter(
        period: ReportPeriod.year,
        referenceDate: DateTime(2025, 8, 1),
      );
      final (start, end) = filter.resolveDateRange();
      expect(start, DateTime(2025, 1, 1));
      expect(end, DateTime(2025, 12, 31, 23, 59, 59, 999));
    });

    test('allTime returns null bounds', () {
      const filter = ReportFilter();
      final (start, end) = filter.resolveDateRange();
      expect(start, isNull);
      expect(end, isNull);
    });
  });

  group('applyReportFilter', () {
    final transactions = [
      _tx(
        type: TransactionType.income,
        amount: 100,
        date: DateTime(2025, 3, 1),
        businessId: 1,
        category: 'Sales',
        tags: ['recurring'],
      ),
      _tx(
        type: TransactionType.expense,
        amount: 40,
        date: DateTime(2025, 3, 10),
        businessId: 2,
        category: 'Rent',
      ),
      _tx(
        type: TransactionType.income,
        amount: 200,
        date: DateTime(2025, 4, 1),
        businessId: 1,
      ),
    ];

    test('filters by month period', () {
      final filter = ReportFilter(
        period: ReportPeriod.month,
        referenceDate: DateTime(2025, 3, 1),
      );
      final result = applyReportFilter(transactions, filter);
      expect(result, hasLength(2));
    });

    test('filters by business id', () {
      const filter = ReportFilter(businessId: 1);
      final result = applyReportFilter(transactions, filter);
      expect(result.every((t) => t.businessId == 1), isTrue);
    });

    test('filters by category', () {
      const filter = ReportFilter(category: 'Sales');
      final result = applyReportFilter(transactions, filter);
      expect(result, hasLength(1));
      expect(result.first.category, 'Sales');
    });

    test('filters by tags', () {
      const filter = ReportFilter(tags: ['recurring']);
      final result = applyReportFilter(transactions, filter);
      expect(result, hasLength(1));
    });
  });
}
