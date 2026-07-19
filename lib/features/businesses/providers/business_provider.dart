import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_database.dart';
import '../models/business.dart';
import '../repositories/business_repository.dart';
import '../repositories/isar_business_repository.dart';

/// Exposes the BusinessRepository implementation.
final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarBusinessRepository(isar);
});

/// Exposes a stream of all businesses from the database.
final watchBusinessesProvider = StreamProvider<List<Business>>((ref) {
  final repo = ref.watch(businessRepositoryProvider);
  return repo.watchBusinesses();
});

/// Sorting options for the business list.
enum BusinessSortOption {
  alphabetical,
  creationDate,
  ownership,
}

/// Represents the filter and sort state of the business list.
class BusinessFilterState {
  const BusinessFilterState({
    this.searchQuery = '',
    this.statusFilter = 'Active', // 'Active', 'Archived', 'All'
    this.categoryFilter,
    this.sortBy = BusinessSortOption.alphabetical,
  });

  final String searchQuery;
  final String statusFilter;
  final String? categoryFilter;
  final BusinessSortOption sortBy;

  BusinessFilterState copyWith({
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
    BusinessSortOption? sortBy,
    bool clearCategory = false,
  }) {
    return BusinessFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: clearCategory ? null : (categoryFilter ?? this.categoryFilter),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// Notifier that manages the filter and search state of the business list.
class BusinessFilterNotifier extends Notifier<BusinessFilterState> {
  @override
  BusinessFilterState build() => const BusinessFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String status) {
    state = state.copyWith(statusFilter: status);
  }

  void setCategoryFilter(String? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(categoryFilter: category);
    }
  }

  void setSortBy(BusinessSortOption sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void reset() {
    state = const BusinessFilterState();
  }
}

/// Provider that exposes the current filter and sort options state.
final businessFilterNotifierProvider =
    NotifierProvider<BusinessFilterNotifier, BusinessFilterState>(
  BusinessFilterNotifier.new,
);

/// Exposes a static list of predefined business categories.
final businessCategoriesProvider = Provider<List<String>>((ref) {
  return [
    'Retail',
    'Real Estate',
    'Tech & SaaS',
    'Services',
    'Agriculture',
    'Food & Beverage',
    'Manufacturing',
    'Transportation',
    'Healthcare',
    'Other',
  ];
});

/// Exposes the reactive list of businesses after applying search, filters, and sorts.
final filteredBusinessesProvider = Provider<AsyncValue<List<Business>>>((ref) {
  final asyncBusinesses = ref.watch(watchBusinessesProvider);
  final filters = ref.watch(businessFilterNotifierProvider);

  return asyncBusinesses.whenData((businesses) {
    // 1. Filter businesses in memory
    final filtered = businesses.where((business) {
      // Apply Search Query
      if (filters.searchQuery.isNotEmpty) {
        final query = filters.searchQuery.toLowerCase();
        final nameMatch = business.name.toLowerCase().contains(query);
        final ownerMatch = business.owner?.toLowerCase().contains(query) ?? false;
        final descMatch = business.description?.toLowerCase().contains(query) ?? false;
        final locMatch = business.location?.toLowerCase().contains(query) ?? false;
        final tagMatch = business.tags.any((tag) => tag.toLowerCase().contains(query));

        if (!nameMatch && !ownerMatch && !descMatch && !locMatch && !tagMatch) {
          return false;
        }
      }

      // Apply Status Filter
      if (filters.statusFilter != 'All' && business.status != filters.statusFilter) {
        return false;
      }

      // Apply Category Filter
      if (filters.categoryFilter != null && business.category != filters.categoryFilter) {
        return false;
      }

      return true;
    }).toList();

    // 2. Sort the filtered list
    switch (filters.sortBy) {
      case BusinessSortOption.alphabetical:
        filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case BusinessSortOption.creationDate:
        filtered.sort((a, b) => b.createdDate.compareTo(a.createdDate)); // Newest first
        break;
      case BusinessSortOption.ownership:
        filtered.sort((a, b) => b.ownershipPercentage.compareTo(a.ownershipPercentage)); // Highest first
        break;
    }

    return filtered;
  });
});
