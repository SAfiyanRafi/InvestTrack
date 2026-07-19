import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_card.dart';
import '../../businesses/providers/business_provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_tile.dart';

/// Screen listing all transaction records in a chronological ledger,
/// offering full search capabilities and interactive filters.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();
  ProviderSubscription<TransactionFilterState>? _filterStateSub;

  @override
  void initState() {
    super.initState();
    _filterStateSub = ref.listenManual<TransactionFilterState>(
      transactionFilterNotifierProvider,
      (previous, next) {
        if (next.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
          _searchController.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    _filterStateSub?.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Watch filtered transactions stream
    final asyncTransactions = ref.watch(filteredTransactionsProvider);
    final filterState = ref.watch(transactionFilterNotifierProvider);
    final filterNotifier = ref.read(transactionFilterNotifierProvider.notifier);

    // Watch business list to map business name dynamically
    final asyncBusinesses = ref.watch(watchBusinessesProvider);
    final businesses = asyncBusinesses.value ?? [];
    final businessMap = {for (final b in businesses) b.id: b.name};

    final isFiltering = filterState.searchQuery.isNotEmpty ||
        filterState.typeFilter != null ||
        filterState.businessIdFilter != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger Timeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Ledger',
            onPressed: () => _showFilterSheet(context, ref),
          ),
          if (isFiltering)
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              tooltip: 'Reset Filters',
              onPressed: () {
                _searchController.clear();
                filterNotifier.reset();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Elegant search container
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p8,
            ),
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search by notes, amount, category...',
              prefixIcon: Icons.search,
              onChanged: (val) => filterNotifier.setSearchQuery(val),
              suffixIcon: filterState.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        filterNotifier.setSearchQuery('');
                      },
                    )
                  : null,
            ),
          ),

          // Active filter summary chips
          if (filterState.typeFilter != null || filterState.businessIdFilter != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (filterState.typeFilter != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSizes.p8),
                        child: InputChip(
                          label: Text(_capitalize(filterState.typeFilter!.name)),
                          onDeleted: () => filterNotifier.setTypeFilter(null),
                        ),
                      ),
                    if (filterState.businessIdFilter != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSizes.p8),
                        child: InputChip(
                          label: Text(businessMap[filterState.businessIdFilter] ?? 'Business'),
                          onDeleted: () => filterNotifier.setBusinessIdFilter(null),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // Ledger timeline items
          Expanded(
            child: asyncTransactions.when(
              loading: () => const AppLoader(message: 'Loading ledger records...'),
              error: (err, stack) => Center(child: Text('Error loading transactions: $err')),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.p32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                          AppSizes.gapH16,
                          Text(
                            isFiltering
                                ? 'No Transactions Found'
                                : 'No Transactions Yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSizes.gapH8,
                          Text(
                            isFiltering
                                ? 'Adjust search filters or tags to locate desired events.'
                                : 'Log your first private investment event using the action button.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          if (!isFiltering) ...[
                            AppSizes.gapH20,
                            FilledButton.icon(
                              onPressed: () => context.push('/transactions/new'),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Transaction'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return AppCard(
                      padding: EdgeInsets.zero,
                      child: TransactionTile(
                        transaction: tx,
                        businessName: businessMap[tx.businessId],
                        onTap: () => context.push('/transactions/${tx.id}/edit'),
                      ),
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
        onPressed: () => context.push('/transactions/new'),
        tooltip: 'Log Transaction',
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
            final filterState = ref.watch(transactionFilterNotifierProvider);
            final filterNotifier = ref.read(transactionFilterNotifierProvider.notifier);
            
            final asyncBusinesses = ref.watch(watchBusinessesProvider);
            final businesses = asyncBusinesses.value ?? [];

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
                        'Filter Ledger',
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

                  // Business filter dropdown
                  Text(
                    'Business Profile',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSizes.gapH8,
                  DropdownButtonFormField<int?>(
                    initialValue: filterState.businessIdFilter,
                    isExpanded: true,
                    menuMaxHeight: 360,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
                      hintText: 'All Businesses',
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('All Businesses'),
                      ),
                      ...businesses.map((b) {
                        return DropdownMenuItem<int?>(
                          value: b.id,
                          child: Text(
                            b.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      filterNotifier.setBusinessIdFilter(value);
                    },
                  ),
                  AppSizes.gapH16,

                  // Transaction Type filter dropdown
                  Text(
                    'Transaction Type',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSizes.gapH8,
                  DropdownButtonFormField<TransactionType?>(
                    initialValue: filterState.typeFilter,
                    isExpanded: true,
                    menuMaxHeight: 360,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
                      hintText: 'All Types',
                    ),
                    items: [
                      const DropdownMenuItem<TransactionType?>(
                        value: null,
                        child: Text('All Types'),
                      ),
                      ...TransactionType.values.map((type) {
                        return DropdownMenuItem<TransactionType?>(
                          value: type,
                          child: Text(
                            _capitalize(type.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      filterNotifier.setTypeFilter(value);
                    },
                  ),
                  AppSizes.gapH24,

                  // Apply button
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

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final words = value.split(regex);
    return words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}
