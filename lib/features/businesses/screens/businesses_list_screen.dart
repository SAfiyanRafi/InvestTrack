import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/business_provider.dart';
import '../widgets/business_card.dart';

/// Screen listing all businesses with search, filtering, and sorting capabilities.
class BusinessesListScreen extends ConsumerWidget {
  const BusinessesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Watch providers
    final asyncBusinesses = ref.watch(filteredBusinessesProvider);
    final filterState = ref.watch(businessFilterNotifierProvider);
    final filterNotifier = ref.read(businessFilterNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Businesses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter List',
            onPressed: () => _showFilterSheet(context, ref),
          ),
          if (filterState.searchQuery.isNotEmpty ||
              filterState.categoryFilter != null ||
              filterState.statusFilter != 'Active')
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              tooltip: 'Reset Filters',
              onPressed: () => filterNotifier.reset(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: AppTextField(
              hintText: 'Search by name, owner, tags...',
              prefixIcon: Icons.search,
              onChanged: (val) => filterNotifier.setSearchQuery(val),
              suffixIcon: filterState.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        filterNotifier.setSearchQuery('');
                      },
                    )
                  : null,
            ),
          ),

          // List content
          Expanded(
            child: asyncBusinesses.when(
              loading: () => const AppLoader(message: 'Loading businesses...'),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (businesses) {
                if (businesses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.p32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_center_outlined,
                            size: 64,
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          AppSizes.gapH16,
                          Text(
                            filterState.searchQuery.isNotEmpty ||
                                    filterState.categoryFilter != null ||
                                    filterState.statusFilter != 'Active'
                                ? 'No Businesses Found'
                                : 'No Businesses Yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSizes.gapH8,
                          Text(
                            filterState.searchQuery.isNotEmpty ||
                                    filterState.categoryFilter != null ||
                                    filterState.statusFilter != 'Active'
                                ? 'Try adjusting your search filters or sort queries.'
                                : 'Add your first business investment profile to get started.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          if (filterState.searchQuery.isEmpty &&
                              filterState.categoryFilter == null &&
                              filterState.statusFilter == 'Active') ...[
                            AppSizes.gapH20,
                            FilledButton.icon(
                              onPressed: () => context.push('/businesses/new'),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Business'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    return BusinessCard(
                      business: business,
                      onTap: () => context.push('/businesses/${business.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/businesses/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final filterState = ref.watch(businessFilterNotifierProvider);
            final filterNotifier = ref.read(
              businessFilterNotifierProvider.notifier,
            );
            final categories = ref.read(businessCategoriesProvider);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter & Sort',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filterNotifier.reset();
                          context.pop();
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  AppSizes.gapH12,

                  // Status Filter
                  Text(
                    'Status',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  Row(
                    children: ['Active', 'Archived', 'All'].map((status) {
                      final isSelected = filterState.statusFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.p8),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              filterNotifier.setStatusFilter(status);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  AppSizes.gapH16,

                  // Category Filter
                  Text(
                    'Category',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  Wrap(
                    spacing: AppSizes.p8,
                    runSpacing: AppSizes.p8,
                    children: [
                      ChoiceChip(
                        label: const Text('All Categories'),
                        selected: filterState.categoryFilter == null,
                        onSelected: (selected) {
                          if (selected) filterNotifier.setCategoryFilter(null);
                        },
                      ),
                      ...categories.map((cat) {
                        final isSelected = filterState.categoryFilter == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            filterNotifier.setCategoryFilter(
                              selected ? cat : null,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                  AppSizes.gapH16,

                  // Sort By Options
                  Text(
                    'Sort By',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  DropdownButtonFormField<BusinessSortOption>(
                    initialValue: filterState.sortBy,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceCard
                          : AppColors.lightSurfaceCard,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: BusinessSortOption.alphabetical,
                        child: Text('Name (A-Z)'),
                      ),
                      DropdownMenuItem(
                        value: BusinessSortOption.creationDate,
                        child: Text('Creation Date (Newest First)'),
                      ),
                      DropdownMenuItem(
                        value: BusinessSortOption.ownership,
                        child: Text('Equity Percentage (Highest First)'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) filterNotifier.setSortBy(value);
                    },
                  ),
                  AppSizes.gapH24,

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
