import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../notifications/providers/notification_event_engine.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/widgets/transaction_tile.dart';
import '../models/business.dart';
import '../providers/business_provider.dart';

/// Screen showing detailed profile information and live financial performance metrics of a [Business].
class BusinessDetailsScreen extends ConsumerStatefulWidget {
  const BusinessDetailsScreen({
    required this.businessId,
    super.key,
  });

  final int businessId;

  @override
  ConsumerState<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends ConsumerState<BusinessDetailsScreen> {
  bool _isLoading = false;

  Future<void> _toggleArchiveStatus(Business business) async {
    setState(() => _isLoading = true);
    final repo = ref.read(businessRepositoryProvider);
    final eventEngine = ref.read(notificationEventEngineProvider);
    
    business.status = business.status == 'Active' ? 'Archived' : 'Active';
    await repo.saveBusiness(business);
    await eventEngine.emitBusinessArchived(
      businessId: business.id,
      businessName: business.name,
      archived: business.status == 'Archived',
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Business status updated to ${business.status}')),
      );
    }
  }

  Future<void> _deleteBusiness() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Business'),
        content: const Text(
          'Are you sure you want to permanently delete this business? '
          'This action cannot be undone and will delete all related records.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final repo = ref.read(businessRepositoryProvider);
      final eventEngine = ref.read(notificationEventEngineProvider);
      String? businessName;
      final currentBusinesses = ref.read(watchBusinessesProvider).valueOrNull;
      if (currentBusinesses != null) {
        for (final item in currentBusinesses) {
          if (item.id == widget.businessId) {
            businessName = item.name;
            break;
          }
        }
      }
      await repo.deleteBusiness(widget.businessId);
      await eventEngine.emitBusinessDeleted(businessName ?? 'Business');
      
      if (mounted) {
        setState(() => _isLoading = false);
        context.pop(); // Pop back to list screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Watch businesses stream to reactively update this screen
    final asyncBusinesses = ref.watch(watchBusinessesProvider);

    // Watch dynamic calculation metrics & transactions for this business
    final asyncMetrics = ref.watch(businessMetricsProvider(widget.businessId));
    final asyncTransactions = ref.watch(watchBusinessTransactionsProvider(widget.businessId));

    return asyncBusinesses.when(
      loading: () => const Scaffold(body: AppLoader(message: 'Loading...')),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (businesses) {
        Business? business;
        for (final item in businesses) {
          if (item.id == widget.businessId) {
            business = item;
            break;
          }
        }

        if (business == null) {
          return const Scaffold(
            body: Center(
              child: Text('This business does not exist or has been deleted.'),
            ),
          );
        }

        final currentBusiness = business;
        final isArchived = currentBusiness.status == 'Archived';
        final formattedDate = DateFormat('MMMM d, y').format(currentBusiness.createdDate);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              currentBusiness.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Business',
                onPressed: () => context.push('/businesses/${currentBusiness.id}/edit'),
              ),
              IconButton(
                icon: Icon(isArchived ? Icons.unarchive : Icons.archive),
                tooltip: isArchived ? 'Restore' : 'Archive',
                onPressed: () => _toggleArchiveStatus(currentBusiness),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete Business',
                onPressed: _deleteBusiness,
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(AppSizes.p16),
                children: [
                  // Business overview banner
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                currentBusiness.name,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.p8,
                                vertical: AppSizes.p4,
                              ),
                              decoration: BoxDecoration(
                                color: (isArchived ? Colors.grey : AppColors.success)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppSizes.r8),
                              ),
                              child: Text(
                                currentBusiness.status,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isArchived ? Colors.grey : AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (currentBusiness.owner != null && currentBusiness.owner!.isNotEmpty) ...[
                          AppSizes.gapH8,
                          Text(
                            'Owner: ${currentBusiness.owner}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                        AppSizes.gapH12,
                        const Divider(),
                        AppSizes.gapH12,
                        _buildDetailRow(context, 'Category', currentBusiness.category ?? 'Other'),
                        _buildDetailRow(context, 'Location', currentBusiness.location ?? 'Not Specified'),
                        _buildDetailRow(
                          context,
                          'Equity Ownership',
                          '${currentBusiness.ownershipPercentage.toInt()}%',
                        ),
                        _buildDetailRow(context, 'Created Date', formattedDate),
                        if (currentBusiness.description != null && currentBusiness.description!.isNotEmpty) ...[
                          AppSizes.gapH12,
                          Text(
                            'Investment Notes',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          AppSizes.gapH4,
                          Text(
                            currentBusiness.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                        if (currentBusiness.tags.isNotEmpty) ...[
                          AppSizes.gapH12,
                          Wrap(
                            spacing: AppSizes.p8,
                            runSpacing: AppSizes.p8,
                            children: currentBusiness.tags.map((tag) {
                              return Chip(label: Text(tag));
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSizes.gapH24,

                  // Dynamic Performance Header (LIVE from Phase 3 calculations)
                  Text(
                    'Financial Metrics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH12,

                  // Bind to calculations
                  asyncMetrics.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.p24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => Text('Error loading metrics: $err'),
                    data: (metrics) {
                      final investedFormatted = CurrencyFormatter.formatCurrency(metrics.totalInvested);
                      final returnsFormatted = CurrencyFormatter.formatCurrency(metrics.totalReturns);
                      final cashFlowFormatted = CurrencyFormatter.formatCurrency(metrics.netCashFlow);
                      final roiFormatted = '${metrics.roi.toStringAsFixed(2)}%';
                      
                      final returnsColor = metrics.totalReturns >= 0 ? AppColors.success : AppColors.error;
                      final cashFlowColor = metrics.netCashFlow >= 0 ? AppColors.success : AppColors.error;
                      final roiColor = metrics.roi >= 0 ? AppColors.success : AppColors.error;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  'Total Invested',
                                  investedFormatted,
                                  Icons.account_balance,
                                ),
                              ),
                              AppSizes.gapW16,
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  'ROI (Yield)',
                                  roiFormatted,
                                  Icons.trending_up,
                                  color: roiColor,
                                ),
                              ),
                            ],
                          ),
                          AppSizes.gapH16,
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  'Total Returns',
                                  returnsFormatted,
                                  Icons.monetization_on,
                                  color: returnsColor,
                                ),
                              ),
                              AppSizes.gapW16,
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  'Net Cash Flow',
                                  cashFlowFormatted,
                                  Icons.swap_horiz,
                                  color: cashFlowColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  AppSizes.gapH24,

                  // Transaction History Timeline
                  Text(
                    'Transaction History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH12,

                  asyncTransactions.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Error: $err'),
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return AppCard(
                          padding: const EdgeInsets.all(AppSizes.p24),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 36,
                                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                ),
                                AppSizes.gapH12,
                                Text(
                                  'No transactions logged yet.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Sort newest first
                      final sorted = List<Transaction>.from(transactions);
                      sorted.sort((a, b) => b.date.compareTo(a.date));

                      return AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            for (var index = 0; index < sorted.length; index++) ...[
                              TransactionTile(
                                transaction: sorted[index],
                                onTap: () => context.push('/transactions/${sorted[index].id}/edit'),
                              ),
                              if (index < sorted.length - 1)
                                const Divider(height: 1, indent: 70),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  AppSizes.gapH24,

                  // Actions
                  AppButton(
                    onPressed: () => context.push('/transactions/new?businessId=${currentBusiness.id}'),
                    icon: Icons.add,
                    text: 'Add Transaction',
                  ),
                  AppSizes.gapH48,
                ],
              ),
              if (_isLoading) const AppLoader(isFullscreen: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: color ??
                (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
