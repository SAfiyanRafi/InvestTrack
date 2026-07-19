import '../../../features/transactions/models/transaction.dart';

/// Preset time windows used by Reports and Analytics.
enum ReportPeriod {
  /// No date restriction — entire ledger history.
  allTime,

  /// A single calendar month anchored to [ReportFilter.referenceDate].
  month,

  /// A calendar quarter containing [ReportFilter.referenceDate].
  quarter,

  /// A calendar year containing [ReportFilter.referenceDate].
  year,

  /// An explicit [ReportFilter.startDate] … [ReportFilter.endDate] range.
  custom,
}

/// Unified filter state shared by Reports, Analytics, and Export.
///
/// All financial views derive metrics from the filtered transaction ledger —
/// nothing is stored permanently.
class ReportFilter {
  const ReportFilter({
    this.period = ReportPeriod.allTime,
    this.referenceDate,
    this.startDate,
    this.endDate,
    this.businessId,
    this.type,
    this.category,
    this.tags = const [],
    this.businessStatus = 'All',
    this.searchQuery = '',
  });

  /// Active preset period selector.
  final ReportPeriod period;

  /// Anchor date for month / quarter / year presets.
  /// Defaults to [DateTime.now] when resolving if null.
  final DateTime? referenceDate;

  /// Inclusive start for [ReportPeriod.custom].
  final DateTime? startDate;

  /// Inclusive end for [ReportPeriod.custom].
  final DateTime? endDate;

  /// Restrict to a single business, or null for all businesses.
  final int? businessId;

  /// Restrict to a single [TransactionType], or null for all types.
  final TransactionType? type;

  /// Restrict to transactions with this category label.
  final String? category;

  /// Restrict to transactions containing **all** listed tags.
  final List<String> tags;

  /// Business status gate: `'Active'`, `'Archived'`, or `'All'`.
  final String businessStatus;

  /// Free-text search across description, category, tags, type, and amount.
  final String searchQuery;

  ReportFilter copyWith({
    ReportPeriod? period,
    DateTime? referenceDate,
    DateTime? startDate,
    DateTime? endDate,
    int? businessId,
    TransactionType? type,
    String? category,
    List<String>? tags,
    String? businessStatus,
    String? searchQuery,
    bool clearBusinessId = false,
    bool clearType = false,
    bool clearCategory = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearReferenceDate = false,
  }) {
    return ReportFilter(
      period: period ?? this.period,
      referenceDate:
          clearReferenceDate ? null : (referenceDate ?? this.referenceDate),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      businessId: clearBusinessId ? null : (businessId ?? this.businessId),
      type: clearType ? null : (type ?? this.type),
      category: clearCategory ? null : (category ?? this.category),
      tags: tags ?? this.tags,
      businessStatus: businessStatus ?? this.businessStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Resolves the inclusive date range implied by [period].
  ///
  /// Returns `(null, null)` for [ReportPeriod.allTime].
  (DateTime? start, DateTime? end) resolveDateRange([DateTime? now]) {
    final anchor = referenceDate ?? now ?? DateTime.now();

    switch (period) {
      case ReportPeriod.allTime:
        return (null, null);
      case ReportPeriod.month:
        final start = DateTime(anchor.year, anchor.month, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 0, 23, 59, 59, 999);
        return (start, end);
      case ReportPeriod.quarter:
        final quarterStartMonth = ((anchor.month - 1) ~/ 3) * 3 + 1;
        final start = DateTime(anchor.year, quarterStartMonth, 1);
        final endMonth = quarterStartMonth + 2;
        final end = DateTime(anchor.year, endMonth + 1, 0, 23, 59, 59, 999);
        return (start, end);
      case ReportPeriod.year:
        final start = DateTime(anchor.year, 1, 1);
        final end = DateTime(anchor.year, 12, 31, 23, 59, 59, 999);
        return (start, end);
      case ReportPeriod.custom:
        return (startDate, endDate);
    }
  }
}
