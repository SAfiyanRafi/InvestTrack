import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';

/// A reusable KPI summary card for the dashboard and future report screens.
///
/// Displays a [title], formatted [value], an [icon], and an optional [subtitle].
/// [color] tints both the icon bubble and the value text to signal
/// positive / negative / neutral state.
///
/// Design notes:
/// - Uses a fixed [minHeight] via [ConstrainedBox] so every card in the same
///   row reaches the same minimum height without relying on [Spacer] or
///   [mainAxisAlignment.spaceBetween], which can cause constraint errors when
///   the cross-axis height of the enclosing [Row] is unconstrained.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.isLarge = false,
    super.key,
  });

  /// Label displayed above the value.
  final String title;

  /// The primary formatted metric string (e.g. 'Rs. 12,340.00' or '14.5%').
  final String value;

  /// Icon rendered inside a tinted bubble.
  final IconData icon;

  /// Accent colour for the icon bubble and value text.
  /// Defaults to the theme's primary colour when null.
  final Color? color;

  /// Optional secondary label displayed below the value (e.g. 'vs last month').
  final String? subtitle;

  /// When true the card uses larger typography — suitable for hero/header cards.
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = color ?? theme.colorScheme.primary;

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.p16),
      child: ConstrainedBox(
        // Minimum height keeps cards uniform in a Row without using Spacer.
        constraints: BoxConstraints(minHeight: isLarge ? 120 : 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon bubble
            Container(
              width: isLarge ? 44 : 36,
              height: isLarge ? 44 : 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
              child: Icon(icon, color: accent, size: isLarge ? 22 : 18),
            ),
            SizedBox(height: isLarge ? 16 : 12),

            // Value — FittedBox scales down text to fit the card width
            // instead of truncating with ellipsis on narrow cards.
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: (isLarge
                        ? theme.textTheme.headlineSmall
                        : theme.textTheme.titleMedium)
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Title
            Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Optional subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
