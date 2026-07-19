import '../../../features/businesses/models/business.dart';
import '../../../features/transactions/models/transaction.dart';
import 'report_filter.dart';

/// A filtered view of the ledger ready for aggregation by Reports and Analytics.
///
/// Produced by [filteredLedgerProvider] — never persisted.
class FilteredLedger {
  const FilteredLedger({
    required this.businesses,
    required this.transactions,
    required this.filter,
  });

  /// Businesses that pass [ReportFilter.businessStatus].
  final List<Business> businesses;

  /// Transactions that pass all active [ReportFilter] criteria.
  final List<Transaction> transactions;

  /// The filter that produced this ledger slice.
  final ReportFilter filter;

  /// Returns true when no transactions match the current filter.
  bool get isEmpty => transactions.isEmpty;
}
