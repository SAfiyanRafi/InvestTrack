import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_database.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/isar_transaction_repository.dart';
import '../utils/transaction_calculator.dart';

/// Exposes the TransactionRepository implementation.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarTransactionRepository(isar);
});

/// Exposes a stream of all transactions in the ledger.
final watchTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchTransactions();
});

/// Exposes a stream of transactions specific to a business ID.
final watchBusinessTransactionsProvider =
    StreamProvider.family<List<Transaction>, int>((ref, businessId) {
      final repo = ref.watch(transactionRepositoryProvider);
      return repo.watchTransactionsForBusiness(businessId);
    });

/// Wrapper class holding computed financial performance statistics for a business.
class BusinessMetrics {
  const BusinessMetrics({
    required this.totalInvested,
    required this.totalReturns,
    required this.netCashFlow,
    required this.roi,
  });

  final double totalInvested;
  final double totalReturns;
  final double netCashFlow;
  final double roi;
}

/// Dynamically calculates business performance metrics from the transaction stream.
final businessMetricsProvider =
    Provider.family<AsyncValue<BusinessMetrics>, int>((ref, businessId) {
      final asyncTransactions = ref.watch(
        watchBusinessTransactionsProvider(businessId),
      );

      return asyncTransactions.whenData((transactions) {
        return BusinessMetrics(
          totalInvested: transactions.calculateTotalInvested(),
          totalReturns: transactions.calculateTotalReturns(),
          netCashFlow: transactions.calculateNetCashFlow(),
          roi: transactions.calculateROI(),
        );
      });
    });

/// Filters configuration state for the transaction timeline.
class TransactionFilterState {
  const TransactionFilterState({
    this.searchQuery = '',
    this.typeFilter,
    this.businessIdFilter,
  });

  final String searchQuery;
  final TransactionType? typeFilter;
  final int? businessIdFilter;

  TransactionFilterState copyWith({
    String? searchQuery,
    TransactionType? typeFilter,
    int? businessIdFilter,
    bool clearType = false,
    bool clearBusiness = false,
  }) {
    return TransactionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearType ? null : (typeFilter ?? this.typeFilter),
      businessIdFilter: clearBusiness
          ? null
          : (businessIdFilter ?? this.businessIdFilter),
    );
  }
}

/// Notifier governing search, type filters, and business filters for the ledger.
class TransactionFilterNotifier extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() => const TransactionFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setTypeFilter(TransactionType? type) {
    if (type == null) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  void setBusinessIdFilter(int? businessId) {
    if (businessId == null) {
      state = state.copyWith(clearBusiness: true);
    } else {
      state = state.copyWith(businessIdFilter: businessId);
    }
  }

  void reset() {
    state = const TransactionFilterState();
  }
}

/// Provider managing active search and filters for global transactions.
final transactionFilterNotifierProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilterState>(
      TransactionFilterNotifier.new,
    );

/// Exposes the dynamically filtered and sorted (newest first) transactions list.
final filteredTransactionsProvider = Provider<AsyncValue<List<Transaction>>>((
  ref,
) {
  final asyncTransactions = ref.watch(watchTransactionsProvider);
  final filters = ref.watch(transactionFilterNotifierProvider);

  return asyncTransactions.whenData((transactions) {
    final filtered = transactions.where((t) {
      // 1. Filter by Search Query
      if (filters.searchQuery.isNotEmpty) {
        final query = filters.searchQuery.toLowerCase();
        final descMatch = t.description?.toLowerCase().contains(query) ?? false;
        final catMatch = t.category?.toLowerCase().contains(query) ?? false;
        final tagMatch = t.tags.any((tag) => tag.toLowerCase().contains(query));
        final typeMatch = t.type.name.toLowerCase().contains(query);
        final amountMatch = t.amount.toString().contains(query);

        if (!descMatch &&
            !catMatch &&
            !tagMatch &&
            !typeMatch &&
            !amountMatch) {
          return false;
        }
      }

      // 2. Filter by Transaction Type
      if (filters.typeFilter != null && t.type != filters.typeFilter) {
        return false;
      }

      // 3. Filter by Related Business ID
      if (filters.businessIdFilter != null &&
          t.businessId != filters.businessIdFilter) {
        return false;
      }

      return true;
    }).toList();

    // 4. Sort newest first
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  });
});
