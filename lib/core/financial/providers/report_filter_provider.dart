import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filtered_ledger.dart';
import '../models/report_filter.dart';
import '../transaction_filters.dart';
import '../../../features/businesses/providers/business_provider.dart';
import '../../../features/transactions/models/transaction.dart';
import '../../../features/transactions/providers/transaction_provider.dart';

/// Shared notifier implementation reused by report-oriented financial modules.
class FinancialFilterNotifier extends Notifier<ReportFilter> {
  @override
  ReportFilter build() => const ReportFilter();

  void setPeriod(ReportPeriod period) {
    state = state.copyWith(period: period);
  }

  void setReferenceDate(DateTime date) {
    state = state.copyWith(referenceDate: date);
  }

  void setCustomDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      period: ReportPeriod.custom,
      startDate: start,
      endDate: end,
    );
  }

  void setBusinessId(int? businessId) {
    if (businessId == null) {
      state = state.copyWith(clearBusinessId: true);
    } else {
      state = state.copyWith(businessId: businessId);
    }
  }

  void setType(TransactionType? type) {
    if (type == null) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(type: type);
    }
  }

  void setCategory(String? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(category: category);
    }
  }

  void setTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  void setBusinessStatus(String status) {
    state = state.copyWith(businessStatus: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void reset() {
    state = const ReportFilter();
  }
}

typedef ReportFilterNotifier = FinancialFilterNotifier;
typedef AnalyticsFilterNotifier = FinancialFilterNotifier;

/// Reports own their filter state because reports are period-based documents.
final reportFilterNotifierProvider =
    NotifierProvider<ReportFilterNotifier, ReportFilter>(
  ReportFilterNotifier.new,
);

/// Analytics own their filter state because analysis is exploratory and should
/// not mutate report selections.
final analyticsFilterNotifierProvider =
    NotifierProvider<AnalyticsFilterNotifier, ReportFilter>(
  AnalyticsFilterNotifier.new,
);

AsyncValue<FilteredLedger> _buildFilteredLedger(
  Ref ref,
  ReportFilter filter,
) {
  final businessesAsync = ref.watch(watchBusinessesProvider);
  final transactionsAsync = ref.watch(watchTransactionsProvider);

  return businessesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (businesses) => transactionsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
      data: (transactions) => AsyncValue.data(
        buildFilteredLedger(
          businesses: businesses,
          transactions: transactions,
          filter: filter,
        ),
      ),
    ),
  );
}

/// Reactive filtered ledger for Reports.
final reportFilteredLedgerProvider = Provider<AsyncValue<FilteredLedger>>((ref) {
  final filter = ref.watch(reportFilterNotifierProvider);
  return _buildFilteredLedger(ref, filter);
});

/// Reactive filtered ledger for Analytics.
final analyticsFilteredLedgerProvider = Provider<AsyncValue<FilteredLedger>>((ref) {
  final filter = ref.watch(analyticsFilterNotifierProvider);
  return _buildFilteredLedger(ref, filter);
});
