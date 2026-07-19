import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/financial/models/report_filter.dart';
import '../../../core/financial/providers/report_filter_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../businesses/providers/business_provider.dart';
import '../../businesses/models/business.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(analyticsFilterNotifierProvider);
    final filterNotifier = ref.read(analyticsFilterNotifierProvider.notifier);
    final businesses = ref.watch(watchBusinessesProvider).valueOrNull ?? const <Business>[];
    final asyncAnalytics = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: asyncAnalytics.when(
        loading: () => const AppLoader(message: 'Preparing analytics...'),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          if (!data.hasTransactionData) {
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
                    child: _buildFilterBar(context, filter, filterNotifier, businesses),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p16)),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                ),
              ],
            );
          }

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
                  child: _buildFilterBar(context, filter, filterNotifier, businesses),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p16)),
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.p16),
                sliver: SliverList.list(
                  children: [
                    _buildSectionCard(
                      context,
                      title: 'Portfolio Growth',
                      subtitle: 'Portfolio value over time',
                      child: _buildLineChart(
                        context,
                        data.portfolioGrowthSeries,
                        color: AppColors.primary,
                        valueFormatter: (value) => CurrencyFormatter.formatCompactCurrency(value),
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'ROI Trend',
                      subtitle: 'Return on investment by month',
                      child: _buildLineChart(
                        context,
                        data.roiTrendSeries,
                        color: AppColors.success,
                        valueFormatter: (value) => '${value.toStringAsFixed(1)}%',
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Income vs Expenses',
                      subtitle: 'Monthly operating comparison',
                      child: _buildIncomeExpenseChart(context, data.incomeExpenseSeries),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Investment Allocation',
                      subtitle: 'Where your invested capital is concentrated',
                      child: _buildPieBreakdown(
                        context,
                        data.investmentAllocation,
                        emptyMessage: 'No invested capital recorded for the current filter.',
                        valueFormatter: (value) => CurrencyFormatter.formatCompactCurrency(value),
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Profit Contribution',
                      subtitle: 'Which businesses are generating profit',
                      child: _buildPieBreakdown(
                        context,
                        data.profitContribution,
                        emptyMessage: 'No positive profit contribution is available yet.',
                        valueFormatter: (value) => CurrencyFormatter.formatCompactCurrency(value),
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Expense Categories',
                      subtitle: 'Where portfolio costs are going',
                      child: _buildPieBreakdown(
                        context,
                        data.expenseCategories,
                        emptyMessage: 'No categorized expenses exist for the current selection.',
                        valueFormatter: (value) => CurrencyFormatter.formatCompactCurrency(value),
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Transaction Distribution',
                      subtitle: 'Composition of ledger activity by type',
                      child: _buildPieBreakdown(
                        context,
                        data.transactionDistribution,
                        emptyMessage: 'No transaction distribution is available yet.',
                        valueFormatter: (value) => value.toStringAsFixed(0),
                      ),
                    ),
                    AppSizes.gapH16,
                    _buildSectionCard(
                      context,
                      title: 'Smart Insights',
                      subtitle: 'Quick interpretation of the current trend set',
                      child: _buildInsights(context, data),
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
    AnalyticsFilterNotifier notifier,
    List<Business> businesses,
  ) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 640;

          final periodField = DropdownButtonFormField<ReportPeriod>(
            initialValue: filter.period,
            isExpanded: true,
            menuMaxHeight: 360,
            decoration: const InputDecoration(labelText: 'Compare Period'),
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
            decoration: const InputDecoration(labelText: 'Compare Businesses'),
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

          final businessField = DropdownButtonFormField<int?>(
            initialValue: filter.businessId,
            isExpanded: true,
            menuMaxHeight: 360,
            decoration: const InputDecoration(labelText: 'Business'),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('All Businesses'),
              ),
              ...businesses.map((business) {
                return DropdownMenuItem<int?>(
                  value: business.id,
                  child: Text(
                    business.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
            onChanged: notifier.setBusinessId,
          );

          final dateField = OutlinedButton.icon(
            onPressed: () => _pickDateScope(context, filter, notifier),
            icon: const Icon(Icons.date_range_outlined),
            label: Text(_dateScopeLabel(filter)),
          );

          if (isCompact) {
            return Column(
              children: [
                periodField,
                AppSizes.gapH12,
                statusField,
                AppSizes.gapH12,
                businessField,
                AppSizes.gapH12,
                SizedBox(width: double.infinity, child: dateField),
              ],
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: periodField),
                  AppSizes.gapW12,
                  Expanded(child: statusField),
                ],
              ),
              AppSizes.gapH12,
              Row(
                children: [
                  Expanded(child: businessField),
                  AppSizes.gapW12,
                  Expanded(child: dateField),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDateScope(
    BuildContext context,
    ReportFilter filter,
    AnalyticsFilterNotifier notifier,
  ) async {
    switch (filter.period) {
      case ReportPeriod.allTime:
        return;
      case ReportPeriod.custom:
        final pickedRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDateRange: filter.startDate != null && filter.endDate != null
              ? DateTimeRange(start: filter.startDate!, end: filter.endDate!)
              : null,
        );
        if (pickedRange != null) {
          notifier.setCustomDateRange(pickedRange.start, pickedRange.end);
        }
        return;
      case ReportPeriod.month:
      case ReportPeriod.quarter:
      case ReportPeriod.year:
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: filter.referenceDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          notifier.setReferenceDate(pickedDate);
        }
        return;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.query_stats,
                size: 44,
                color: AppColors.secondary,
              ),
            ),
            AppSizes.gapH24,
            Text(
              'No transaction data available yet.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSizes.gapH12,
            Text(
              'Add businesses and transactions to generate portfolio analytics.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSizes.gapH24,
            FilledButton.icon(
              onPressed: () => context.push('/transactions/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSizes.gapH4,
          Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
          AppSizes.gapH12,
          child,
        ],
      ),
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<dynamic> series, {
    required Color color,
    required String Function(double value) valueFormatter,
  }) {
    if (series.isEmpty) {
      return _buildInlineEmpty('No chart data for the current filter.');
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (series.length - 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: color.withValues(alpha: 0.12),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 54,
                getTitlesWidget: (value, meta) => Text(
                  valueFormatter(value),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= series.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('MMM').format(series[index].period as DateTime),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: color,
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.12),
              ),
              spots: List.generate(
                series.length,
                (index) => FlSpot(index.toDouble(), series[index].value as double),
              ),
              barWidth: 3,
              dotData: FlDotData(show: series.length == 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseChart(BuildContext context, List<dynamic> series) {
    if (series.isEmpty) {
      return _buildInlineEmpty('No income or expense activity for the current filter.');
    }

    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) => Text(
                  CurrencyFormatter.formatCompactCurrency(value),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= series.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('MMM').format(series[index].period as DateTime),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(series.length, (index) {
            final point = series[index];
            return BarChartGroupData(
              x: index,
              barsSpace: 6,
              barRods: [
                BarChartRodData(
                  toY: point.income as double,
                  color: AppColors.success,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: point.expenses as double,
                  color: AppColors.error,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPieBreakdown(
    BuildContext context,
    List<dynamic> entries, {
    required String emptyMessage,
    required String Function(double value) valueFormatter,
  }) {
    final filtered = entries.where((entry) => (entry.value as double) > 0).toList();
    if (filtered.isEmpty) {
      return _buildInlineEmpty(emptyMessage);
    }

    final colors = _chartColors;
    final total = filtered.fold<double>(0, (sum, entry) => sum + (entry.value as double));

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 36,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(enabled: true),
              sections: List.generate(filtered.length, (index) {
                final entry = filtered[index];
                final color = colors[index % colors.length];
                final percent = ((entry.value as double) / total) * 100;
                return PieChartSectionData(
                  value: entry.value as double,
                  color: color,
                  radius: 58,
                  title: '${percent.toStringAsFixed(0)}%',
                  titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                );
              }),
            ),
          ),
        ),
        AppSizes.gapH12,
        for (var index = 0; index < filtered.length; index++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                AppSizes.gapW8,
                Expanded(child: Text(filtered[index].label as String)),
                Text(valueFormatter(filtered[index].value as double)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInsights(BuildContext context, AnalyticsData data) {
    final theme = Theme.of(context);
    final insights = <String>[
      if (data.bestPerformer != null)
        '${data.bestPerformer!.business.name} currently leads with ${data.bestPerformer!.roi.toStringAsFixed(1)}% ROI.',
      if (data.worstPerformer != null)
        '${data.worstPerformer!.business.name} is the weakest performer in the current comparison set.',
      if (data.expenseCategories.isNotEmpty)
        '${data.expenseCategories.first.label} is the largest expense category in the selected range.',
      'Analytics are derived live from ${data.transactionDistribution.fold<double>(0, (sum, entry) => sum + entry.value).toStringAsFixed(0)} filtered transactions.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final insight in insights)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.p8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.insights_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSizes.gapW8,
                Expanded(child: Text(insight)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInlineEmpty(String message) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _dateScopeLabel(ReportFilter filter) {
    switch (filter.period) {
      case ReportPeriod.allTime:
        return 'All History';
      case ReportPeriod.month:
        return DateFormat('MMMM y').format(filter.referenceDate ?? DateTime.now());
      case ReportPeriod.quarter:
        final date = filter.referenceDate ?? DateTime.now();
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${date.year}';
      case ReportPeriod.year:
        return '${(filter.referenceDate ?? DateTime.now()).year}';
      case ReportPeriod.custom:
        if (filter.startDate == null || filter.endDate == null) {
          return 'Choose Range';
        }
        return '${DateFormat('d MMM y').format(filter.startDate!)} - ${DateFormat('d MMM y').format(filter.endDate!)}';
    }
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

  List<Color> get _chartColors => const [
        AppColors.primary,
        AppColors.secondary,
        AppColors.success,
        AppColors.warning,
        AppColors.error,
        Color(0xFF0EA5E9),
        Color(0xFF14B8A6),
        Color(0xFFF97316),
      ];
}
