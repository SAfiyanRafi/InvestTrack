import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/financial/models/report_filter.dart';
import '../../../core/financial/providers/report_filter_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../providers/portfolio_report_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(reportFilterNotifierProvider);
    final filterNotifier = ref.read(reportFilterNotifierProvider.notifier);
    final asyncReport = ref.watch(portfolioReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: asyncReport.when(
        loading: () => const AppLoader(message: 'Building reports...'),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (report) {
          if (report.isEmpty) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.p16,
                      AppSizes.p12,
                      AppSizes.p16,
                      0,
                    ),
                    child: _buildFilterBar(context, filter, filterNotifier),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p16)),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p24),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.summarize_outlined,
                            size: 56,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          AppSizes.gapH16,
                          Text(
                            'No reports available',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          AppSizes.gapH8,
                          Text(
                            'Add transactions or adjust the selected period to generate report summaries.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final summary = report.summary;
          final periodLabel = _periodValueLabel(filter);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.p16,
                    AppSizes.p12,
                    AppSizes.p16,
                    0,
                  ),
                  child: _buildFilterBar(context, filter, filterNotifier),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p16)),
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.p16),
                sliver: SliverList.list(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio Report',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          AppSizes.gapH8,
                          _reportMetaRow(context, 'Period', periodLabel),
                          _reportMetaRow(context, 'Business Status', filter.businessStatus),
                          _reportMetaRow(context, 'Businesses Included', '${report.businessCount}'),
                          _reportMetaRow(context, 'Transactions Included', '${report.transactionCount}'),
                        ],
                      ),
                    ),
                    AppSizes.gapH24,
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statement Summary',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          AppSizes.gapH12,
                          _reportValueRow(context, 'Total Invested', CurrencyFormatter.formatCurrency(summary.totalInvested)),
                          _reportValueRow(context, 'Income', CurrencyFormatter.formatCurrency(summary.totalIncome)),
                          _reportValueRow(context, 'Expenses', CurrencyFormatter.formatCurrency(summary.totalExpenses)),
                          _reportValueRow(context, 'Taxes', CurrencyFormatter.formatCurrency(summary.totalTaxes)),
                          _reportValueRow(context, 'Withdrawals', CurrencyFormatter.formatCurrency(summary.totalWithdrawals)),
                          _reportValueRow(context, 'Net Profit', CurrencyFormatter.formatCurrency(summary.netProfit), emphasize: true),
                          _reportValueRow(context, 'ROI', '${summary.portfolioRoi.toStringAsFixed(2)}%'),
                          _reportValueRow(context, 'Remaining Capital', CurrencyFormatter.formatCurrency(summary.portfolioValue), emphasize: true),
                        ],
                      ),
                    ),
                    AppSizes.gapH24,
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Breakdown',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          AppSizes.gapH12,
                          for (final month in report.monthlySnapshots.reversed.take(6))
                            _reportValueRow(
                              context,
                              DateFormat('MMM y').format(month.month),
                              CurrencyFormatter.formatCurrency(month.netProfit),
                            ),
                        ],
                      ),
                    ),
                    AppSizes.gapH24,
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Business Summary',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          AppSizes.gapH12,
                          for (final performance in report.businessPerformances.take(5))
                            _reportValueRow(
                              context,
                              performance.business.name,
                              CurrencyFormatter.formatCurrency(performance.netProfit),
                              subtitle: 'ROI ${performance.roi.toStringAsFixed(1)}%',
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    ReportFilter filter,
    ReportFilterNotifier notifier,
  ) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 640;

          final periodField = DropdownButtonFormField<ReportPeriod>(
            initialValue: filter.period,
            isExpanded: true,
            menuMaxHeight: 360,
            decoration: const InputDecoration(labelText: 'Period'),
            items: ReportPeriod.values
                .map(
                  (period) => DropdownMenuItem(
                    value: period,
                    child: Text(
                      _periodLabel(period),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                notifier.setPeriod(value);
              }
            },
          );

          final statusField = DropdownButtonFormField<String>(
            initialValue: filter.businessStatus,
            isExpanded: true,
            menuMaxHeight: 360,
            decoration: const InputDecoration(labelText: 'Business Status'),
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All')),
              DropdownMenuItem(value: 'Active', child: Text('Active')),
              DropdownMenuItem(value: 'Archived', child: Text('Archived')),
            ],
            onChanged: (value) {
              if (value != null) {
                notifier.setBusinessStatus(value);
              }
            },
          );

          if (isCompact) {
            return Column(
              children: [
                periodField,
                AppSizes.gapH12,
                statusField,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: periodField),
              AppSizes.gapW12,
              Expanded(child: statusField),
            ],
          );
        },
      ),
    );
  }

  String _periodLabel(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.allTime:
        return 'All Time';
      case ReportPeriod.month:
        return 'Month';
      case ReportPeriod.quarter:
        return 'Quarter';
      case ReportPeriod.year:
        return 'Year';
      case ReportPeriod.custom:
        return 'Custom';
    }
  }

  String _periodValueLabel(ReportFilter filter) {
    switch (filter.period) {
      case ReportPeriod.allTime:
        return 'All Time';
      case ReportPeriod.month:
        return DateFormat('MMMM y').format(filter.referenceDate ?? DateTime.now());
      case ReportPeriod.quarter:
        final date = filter.referenceDate ?? DateTime.now();
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${date.year}';
      case ReportPeriod.year:
        return '${(filter.referenceDate ?? DateTime.now()).year}';
      case ReportPeriod.custom:
        final start = filter.startDate;
        final end = filter.endDate;
        if (start == null || end == null) return 'Custom Range';
        return '${DateFormat('d MMM y').format(start)} - ${DateFormat('d MMM y').format(end)}';
    }
  }

  Widget _reportMetaRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _reportValueRow(
    BuildContext context,
    String label,
    String value, {
    bool emphasize = false,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
