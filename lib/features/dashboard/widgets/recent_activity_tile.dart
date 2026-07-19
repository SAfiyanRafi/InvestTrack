import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../transactions/models/transaction.dart';

/// A compact activity tile for the Recent Activity feed on the Dashboard.
///
/// Displays the transaction type icon, human-readable type label, business name,
/// formatted amount, and date. Reuses the same icon/colour conventions as
/// [TransactionTile] for visual consistency.
class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    required this.transaction,
    required this.businessName,
    required this.onTap,
    super.key,
  });

  final Transaction transaction;

  /// Display name of the business this transaction belongs to.
  final String businessName;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final details = _resolveDetails(transaction.type);
    final formattedAmount = CurrencyFormatter.formatSignedCurrency(
      details.sign == '-' ? -transaction.amount : transaction.amount,
    );
    final formattedDate = DateFormat('MMM d').format(transaction.date);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        child: Row(
          children: [
            // Transaction icon bubble
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: details.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(details.icon, color: details.color, size: 18),
            ),
            AppSizes.gapW12,

            // Type + business name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    businessName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSizes.gapW8,

            // Amount + date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: details.color,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  formattedDate,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _TxDetails _resolveDetails(TransactionType type) {
    switch (type) {
      case TransactionType.investment:
        return const _TxDetails(
            label: 'Investment',
            icon: Icons.account_balance,
            color: AppColors.primary,
            sign: '');
      case TransactionType.additionalInvestment:
        return const _TxDetails(
            label: 'Add. Investment',
            icon: Icons.add_business,
            color: AppColors.primary,
            sign: '');
      case TransactionType.income:
        return const _TxDetails(
            label: 'Income',
            icon: Icons.monetization_on,
            color: AppColors.success,
            sign: '+');
      case TransactionType.dividend:
        return const _TxDetails(
            label: 'Dividend',
            icon: Icons.pie_chart,
            color: AppColors.success,
            sign: '+');
      case TransactionType.expense:
        return const _TxDetails(
            label: 'Expense',
            icon: Icons.shopping_bag,
            color: AppColors.error,
            sign: '-');
      case TransactionType.withdrawal:
        return const _TxDetails(
            label: 'Withdrawal',
            icon: Icons.arrow_downward,
            color: AppColors.error,
            sign: '-');
      case TransactionType.loan:
        return const _TxDetails(
            label: 'Loan',
            icon: Icons.handshake,
            color: AppColors.warning,
            sign: '+');
      case TransactionType.loanRepayment:
        return const _TxDetails(
            label: 'Loan Repayment',
            icon: Icons.assignment_turned_in,
            color: AppColors.error,
            sign: '-');
      case TransactionType.assetPurchase:
        return const _TxDetails(
            label: 'Asset Purchase',
            icon: Icons.shopping_cart,
            color: AppColors.error,
            sign: '-');
      case TransactionType.assetSale:
        return const _TxDetails(
            label: 'Asset Sale',
            icon: Icons.sell,
            color: AppColors.success,
            sign: '+');
      case TransactionType.tax:
        return const _TxDetails(
            label: 'Tax',
            icon: Icons.percent,
            color: AppColors.error,
            sign: '-');
      case TransactionType.other:
        return const _TxDetails(
            label: 'Other',
            icon: Icons.info,
            color: Color(0xFF607D8B),
            sign: '');
    }
  }
}

/// Internal value object holding resolved display attributes for a transaction type.
class _TxDetails {
  const _TxDetails({
    required this.label,
    required this.icon,
    required this.color,
    required this.sign,
  });
  final String label;
  final IconData icon;
  final Color color;
  final String sign;
}
