import '../../features/businesses/models/business.dart';
import '../../features/transactions/models/transaction.dart';
import 'models/filtered_ledger.dart';
import 'models/report_filter.dart';

/// Returns transactions whose [Transaction.date] falls in the given calendar month.
///
/// Comparison uses year + month only — the day component is ignored.
List<Transaction> filterByMonth(
  Iterable<Transaction> transactions,
  DateTime month,
) {
  return transactions
      .where((t) => t.date.year == month.year && t.date.month == month.month)
      .toList();
}

/// Returns transactions whose [Transaction.date] falls within [start] … [end] inclusive.
List<Transaction> filterByDateRange(
  Iterable<Transaction> transactions,
  DateTime start,
  DateTime end,
) {
  final normalizedStart = DateTime(start.year, start.month, start.day);
  final normalizedEnd = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

  return transactions.where((t) {
    final date = DateTime(t.date.year, t.date.month, t.date.day);
    return !date.isBefore(normalizedStart) && !date.isAfter(normalizedEnd);
  }).toList();
}

/// Returns transactions for the calendar quarter containing [reference].
List<Transaction> filterByQuarter(
  Iterable<Transaction> transactions,
  DateTime reference,
) {
  final (start, end) = const ReportFilter(
    period: ReportPeriod.quarter,
  ).copyWith(referenceDate: reference).resolveDateRange(reference);

  if (start == null || end == null) return transactions.toList();
  return filterByDateRange(transactions, start, end);
}

/// Returns transactions for the calendar year containing [reference].
List<Transaction> filterByYear(
  Iterable<Transaction> transactions,
  DateTime reference,
) {
  final (start, end) = const ReportFilter(
    period: ReportPeriod.year,
  ).copyWith(referenceDate: reference).resolveDateRange(reference);

  if (start == null || end == null) return transactions.toList();
  return filterByDateRange(transactions, start, end);
}

/// Filters [businesses] by [ReportFilter.businessStatus].
List<Business> filterBusinessesByStatus(
  Iterable<Business> businesses,
  String statusFilter,
) {
  if (statusFilter == 'All') return businesses.toList();
  return businesses.where((b) => b.status == statusFilter).toList();
}

/// Applies the full [ReportFilter] to raw ledger data.
///
/// Business status is applied first so transaction scoping respects the
/// active business set unless a specific [ReportFilter.businessId] is set.
List<Transaction> applyReportFilter(
  Iterable<Transaction> transactions,
  ReportFilter filter, {
  Iterable<Business>? businesses,
  DateTime? now,
}) {
  var result = transactions.toList();

  // Scope to businesses matching the status filter.
  if (businesses != null && filter.businessStatus != 'All') {
    final allowedIds = filterBusinessesByStatus(
      businesses,
      filter.businessStatus,
    ).map((b) => b.id).toSet();
    result = result.where((t) => allowedIds.contains(t.businessId)).toList();
  }

  // Business ID filter takes precedence over status scoping when both apply.
  if (filter.businessId != null) {
    result = result.where((t) => t.businessId == filter.businessId).toList();
  }

  // Date range filter.
  final (start, end) = filter.resolveDateRange(now);
  if (start != null && end != null) {
    result = filterByDateRange(result, start, end);
  }

  // Transaction type filter.
  if (filter.type != null) {
    result = result.where((t) => t.type == filter.type).toList();
  }

  // Category filter.
  if (filter.category != null) {
    result = result
        .where(
          (t) => t.category?.toLowerCase() == filter.category!.toLowerCase(),
        )
        .toList();
  }

  // Tags filter — transaction must contain every listed tag.
  if (filter.tags.isNotEmpty) {
    result = result.where((t) {
      final txTags = t.tags.map((tag) => tag.toLowerCase()).toSet();
      return filter.tags.every((tag) => txTags.contains(tag.toLowerCase()));
    }).toList();
  }

  // Free-text search.
  if (filter.searchQuery.isNotEmpty) {
    final query = filter.searchQuery.toLowerCase();
    result = result.where((t) {
      final descMatch = t.description?.toLowerCase().contains(query) ?? false;
      final catMatch = t.category?.toLowerCase().contains(query) ?? false;
      final tagMatch = t.tags.any((tag) => tag.toLowerCase().contains(query));
      final typeMatch = t.type.name.toLowerCase().contains(query);
      final amountMatch = t.amount.toString().contains(query);
      return descMatch || catMatch || tagMatch || typeMatch || amountMatch;
    }).toList();
  }

  return result;
}

/// Builds a [FilteredLedger] by applying [filter] to raw database lists.
FilteredLedger buildFilteredLedger({
  required List<Business> businesses,
  required List<Transaction> transactions,
  required ReportFilter filter,
  DateTime? now,
}) {
  final filteredBusinesses = filterBusinessesByStatus(
    businesses,
    filter.businessStatus,
  );
  final filteredTransactions = applyReportFilter(
    transactions,
    filter,
    businesses: businesses,
    now: now,
  );

  return FilteredLedger(
    businesses: filteredBusinesses,
    transactions: filteredTransactions,
    filter: filter,
  );
}
