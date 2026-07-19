import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../notifications/models/app_notification.dart';
import '../../notifications/models/reminder.dart';
import '../../notifications/providers/notification_provider.dart';
import '../../notifications/providers/reminder_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../models/dashboard_data.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/business_rank_tile.dart';
import '../widgets/recent_activity_tile.dart';
import '../widgets/summary_card.dart';

/// The application home screen — a real-time portfolio overview.
///
/// This widget is a pure renderer. It watches [dashboardProvider] once and
/// maps [DashboardData] fields directly to pre-built widget props.
/// Zero financial calculations occur here.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDashboard = ref.watch(dashboardProvider);
    final unreadNotifications = ref.watch(unreadNotificationsCountProvider);
    final upcomingReminder = ref.watch(upcomingReminderProvider);
    final recentNotifications = ref.watch(recentNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestTrack'),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_outlined),
                if (unreadNotifications > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        unreadNotifications > 99 ? '99+' : '$unreadNotifications',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => context.push('/notifications'),
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: asyncDashboard.when(
        loading: () => const AppLoader(message: 'Calculating portfolio...'),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          if (data.hasNoData) return _buildEmptyState(context);
          return _DashboardContent(
            data: data,
            upcomingReminder: upcomingReminder,
            recentNotifications: recentNotifications,
          );
        },
      ),
    );
  }

  // ── Portfolio Hero ─────────────────────────────────────────────────────────

  Widget _buildPortfolioHero(BuildContext context, DashboardData data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final summary = data.summary;

    final portfolioFormatted = CurrencyFormatter.formatCurrency(summary.portfolioValue);
    final profitFormatted = CurrencyFormatter.formatSignedCurrency(summary.netProfit);
    final roiFormatted =
        '${summary.portfolioRoi >= 0 ? '+' : ''}${summary.portfolioRoi.toStringAsFixed(2)}%';

    final profitColor = summary.netProfit >= 0 ? AppColors.success : AppColors.error;
    final roiColor = summary.portfolioRoi >= 0 ? AppColors.success : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primary.withValues(alpha: 0.25),
                  AppColors.darkSurface,
                ]
              : [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.lightSurface,
                ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.r20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          AppSizes.gapH8,
          Text(
            portfolioFormatted,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          AppSizes.gapH16,
          Wrap(
            spacing: AppSizes.p12,
            runSpacing: AppSizes.p8,
            children: [
              _heroChip(context, profitFormatted, 'Net Profit', profitColor),
              _heroChip(context, roiFormatted, 'ROI', roiColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(
      BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p12, vertical: AppSizes.p8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ── KPI Grid ───────────────────────────────────────────────────────────────

  Widget _buildKpiGrid(BuildContext context, DashboardData data) {
    final summary = data.summary;
    final cashFlowColor =
        summary.netCashFlow >= 0 ? AppColors.success : AppColors.error;
    final netProfitColor =
        summary.netProfit >= 0 ? AppColors.success : AppColors.error;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Invested',
                value: CurrencyFormatter.formatCurrency(
                  summary.totalInvested,
                  decimalDigits: 0,
                ),
                icon: Icons.account_balance_outlined,
                color: AppColors.primary,
              ),
            ),
            AppSizes.gapW12,
            Expanded(
              child: SummaryCard(
                title: 'Net Profit',
                value: CurrencyFormatter.formatSignedCurrency(
                  summary.netProfit,
                  decimalDigits: 0,
                ),
                icon: Icons.trending_up,
                color: netProfitColor,
              ),
            ),
          ],
        ),
        AppSizes.gapH12,
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Net Cash Flow',
                value: CurrencyFormatter.formatSignedCurrency(
                  summary.netCashFlow,
                  decimalDigits: 0,
                ),
                icon: Icons.swap_horiz,
                color: cashFlowColor,
              ),
            ),
            AppSizes.gapW12,
            Expanded(
              child: SummaryCard(
                title: 'Active Businesses',
                value: '${data.activeBusinessCount}',
                icon: Icons.business_outlined,
                subtitle: '${data.totalBusinessCount} total',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Monthly Snapshot ───────────────────────────────────────────────────────

  Widget _buildMonthlySnapshot(BuildContext context, DashboardData data) {
    final snap = data.monthlySnapshot;
    final profitColor = snap.netProfit >= 0 ? AppColors.success : AppColors.error;

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Income',
            value: CurrencyFormatter.formatCurrency(
              snap.income,
              decimalDigits: 0,
            ),
            icon: Icons.arrow_upward,
            color: AppColors.success,
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: SummaryCard(
            title: 'Expenses',
            value: CurrencyFormatter.formatCurrency(
              snap.expenses,
              decimalDigits: 0,
            ),
            icon: Icons.arrow_downward,
            color: AppColors.error,
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: SummaryCard(
            title: 'Net Profit',
            value: CurrencyFormatter.formatSignedCurrency(
              snap.netProfit,
              decimalDigits: 0,
            ),
            icon: Icons.bar_chart,
            color: profitColor,
          ),
        ),
      ],
    );
  }

  // ── Business Rankings ──────────────────────────────────────────────────────

  Widget _buildBusinessRankings(BuildContext context, DashboardData data) {
    // Show top 5 on dashboard; user can navigate to full list
    final top = data.businessRankings.take(5).toList();

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < top.length; index++) ...[
            BusinessRankTile(
              performance: top[index],
              rank: index + 1,
              onTap: () => context.push('/businesses/${top[index].businessId}'),
            ),
            if (index < top.length - 1)
              const Divider(height: 1, indent: AppSizes.p16),
          ],
        ],
      ),
    );
  }

  // ── Recent Activity ────────────────────────────────────────────────────────

  Widget _buildRecentActivity(BuildContext context, DashboardData data) {
    // Build a map of businessId -> name for O(1) lookups
    final businessMap = {
      for (final perf in data.businessRankings)
        perf.businessId: perf.business.name,
    };

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < data.recentTransactions.length; index++) ...[
            Builder(
              builder: (context) {
                final tx = data.recentTransactions[index];
                return RecentActivityTile(
                  transaction: tx,
                  businessName: businessMap[tx.businessId] ?? 'Business',
                  onTap: () => context.push('/transactions/${tx.id}/edit'),
                );
              },
            ),
            if (index < data.recentTransactions.length - 1)
              const Divider(height: 1, indent: AppSizes.p16),
          ],
        ],
      ),
    );
  }

  // ── Quick Actions ──────────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.add_business_outlined,
            label: 'Add Business',
            onTap: () => context.push('/businesses/new'),
            color: AppColors.primary,
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.receipt_long_outlined,
            label: 'Add Transaction',
            onTap: () => context.push('/transactions/new'),
            color: AppColors.secondary,
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.bar_chart_outlined,
            label: 'Reports',
            onTap: () => context.go('/reports'),
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.p16, horizontal: AppSizes.p8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            AppSizes.gapH8,
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.p16),
            sliver: SliverList.list(
              children: [
                RepaintBoundary(
                  child: _buildPortfolioHero(
                    context,
                    DashboardData.empty,
                  ),
                ),
                AppSizes.gapH16,
                const RepaintBoundary(
                  child: AppCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Total Invested',
                                value: 'Rs. 0',
                                icon: Icons.account_balance_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                            AppSizes.gapW12,
                            Expanded(
                              child: SummaryCard(
                                title: 'Net Profit',
                                value: 'Rs. 0',
                                icon: Icons.trending_up,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        AppSizes.gapH12,
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Net Cash Flow',
                                value: 'Rs. 0',
                                icon: Icons.swap_horiz,
                                color: AppColors.success,
                              ),
                            ),
                            AppSizes.gapW12,
                            Expanded(
                              child: SummaryCard(
                                title: 'ROI',
                                value: '0%',
                                icon: Icons.percent,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizes.gapH24,
                RepaintBoundary(
                  child: AppCard(
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.business_center_outlined,
                            size: 44,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSizes.gapH16,
                        Text(
                          'No businesses yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSizes.gapH8,
                        Text(
                          'Create your first business to start tracking live performance and portfolio growth.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSizes.gapH20,
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 360;
                            if (compact) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: () => context.push('/businesses/new'),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Business'),
                                    ),
                                  ),
                                  AppSizes.gapH8,
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () => context.push('/transactions/new'),
                                      icon: const Icon(Icons.help_outline),
                                      label: const Text('Learn How'),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => context.push('/businesses/new'),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Business'),
                                  ),
                                ),
                                AppSizes.gapW12,
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => context.push('/transactions/new'),
                                    icon: const Icon(Icons.help_outline),
                                    label: const Text('Learn How'),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizes.gapH24,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
      BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  String _currentMonthLabel() {
    return DateFormat('MMMM y').format(DateTime.now());
  }

  Widget _buildUpcomingReminderCard(BuildContext context, Reminder reminder) {
    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
          child: const Icon(Icons.alarm_outlined, color: AppColors.warning),
        ),
        title: const Text('Next Reminder'),
        subtitle: Text(
          '${reminder.title}\n${DateFormat('EEE, d MMM y  h:mm a').format(reminder.dueDate)}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/notifications'),
      ),
    );
  }

  Widget _buildRecentNotificationsCard(
    BuildContext context,
    List<AppNotification> notifications,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < notifications.length; index++) ...[
            ListTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                color: _notificationTypeColor(notifications[index].type),
              ),
              title: Text(notifications[index].title),
              subtitle: Text(
                DateFormat('d MMM, h:mm a').format(notifications[index].timestamp),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/notifications'),
            ),
            if (index < notifications.length - 1)
              const Divider(height: 1, indent: AppSizes.p16),
          ],
        ],
      ),
    );
  }

  Color _notificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.informational:
        return AppColors.primary;
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.critical:
        return AppColors.error;
    }
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.data,
    required this.upcomingReminder,
    required this.recentNotifications,
  });

  final DashboardData data;
  final Reminder? upcomingReminder;
  final List<AppNotification> recentNotifications;

  @override
  Widget build(BuildContext context) {
    const screen = DashboardScreen();

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p8)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          sliver: SliverToBoxAdapter(
            child: RepaintBoundary(
              child: screen._buildPortfolioHero(context, data),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          sliver: SliverToBoxAdapter(
            child: RepaintBoundary(
              child: screen._buildKpiGrid(context, data),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          sliver: SliverToBoxAdapter(
            child: screen._buildSectionHeader(
              context,
              'Monthly Snapshot',
              screen._currentMonthLabel(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          sliver: SliverToBoxAdapter(
            child: RepaintBoundary(
              child: screen._buildMonthlySnapshot(context, data),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        if (data.businessRankings.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: screen._buildSectionHeader(
                context,
                'Business Rankings',
                'By net profit',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: RepaintBoundary(
                child: screen._buildBusinessRankings(context, data),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        ],
        if (data.recentTransactions.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: screen._buildSectionHeader(
                context,
                'Recent Activity',
                'Last 10 transactions',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: RepaintBoundary(
                child: screen._buildRecentActivity(context, data),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        ],
        if (upcomingReminder != null) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: screen._buildSectionHeader(
                context,
                'Upcoming Reminder',
                'Stay on track',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: RepaintBoundary(
                child: screen._buildUpcomingReminderCard(context, upcomingReminder!),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        ],
        if (recentNotifications.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: screen._buildSectionHeader(
                context,
                'Recent Notifications',
                'Latest 3',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            sliver: SliverToBoxAdapter(
              child: RepaintBoundary(
                child: screen._buildRecentNotificationsCard(context, recentNotifications),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p24)),
        ],
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          sliver: SliverToBoxAdapter(
            child: RepaintBoundary(
              child: screen._buildQuickActions(context),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.p48)),
      ],
    );
  }
}
