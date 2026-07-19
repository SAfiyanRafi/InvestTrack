import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/business_performance.dart';

/// A ranked list tile displaying a single [BusinessPerformance] entry.
///
/// Shows the rank number, business name, category, net profit, and ROI.
/// Tapping navigates to the Business Details screen via [onTap].
class BusinessRankTile extends StatelessWidget {
  const BusinessRankTile({
    required this.performance,
    required this.rank,
    required this.onTap,
    super.key,
  });

  /// The performance data for this business.
  final BusinessPerformance performance;

  /// 1-based ranking position (1 = best performer).
  final int rank;

  /// Callback invoked when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final profitColor =
        performance.netProfit >= 0 ? AppColors.success : AppColors.error;
    final roiColor = performance.roi >= 0 ? AppColors.success : AppColors.error;

    final formattedProfit = CurrencyFormatter.formatSignedCurrency(performance.netProfit);
    final formattedRoi =
        '${performance.roi >= 0 ? '+' : ''}${performance.roi.toStringAsFixed(1)}%';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _rankColor(rank).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _rankColor(rank),
                  ),
                ),
              ),
            ),
            AppSizes.gapW12,

            // Name + category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    performance.business.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    performance.business.category ?? 'Other',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppSizes.gapW12,

            // Net profit + ROI
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedProfit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: profitColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ROI $formattedRoi',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: roiColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Gold / Silver / Bronze colours for the top 3; neutral thereafter.
  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFF59E0B); // Gold
      case 2:
        return const Color(0xFF94A3B8); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.primary;
    }
  }
}
