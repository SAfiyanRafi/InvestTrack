import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/transaction.dart';

/// A list tile representing a single [Transaction] record on a timeline.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.onTap,
    this.businessName,
    super.key,
  });

  final Transaction transaction;
  final VoidCallback onTap;

  /// Optional name of the business this transaction belongs to (shown in global lists)
  final String? businessName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve details based on TransactionType
    final details = _getTransactionDetails(transaction.type);

    // Amount styling
    final sign = details.amountSign;
    final amountColor = details.amountColor;

    final signedAmount = sign == '-' ? -transaction.amount : transaction.amount;
    final formattedAmount = CurrencyFormatter.formatSignedCurrency(
      signedAmount,
    );
    final formattedDate = DateFormat('MMM d, y').format(transaction.date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 380;

            final metaDateStyle = theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            );

            final amountWidget = ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: compact ? constraints.maxWidth : 120,
              ),
              child: Column(
                crossAxisAlignment: compact
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formattedAmount,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                  ),
                  if (transaction.attachmentPath != null &&
                      transaction.attachmentPath!.isNotEmpty) ...[
                    AppSizes.gapH4,
                    Icon(
                      Icons.attach_file,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ],
              ),
            );

            final detailWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description?.isNotEmpty == true
                      ? transaction.description!
                      : details.typeName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSizes.gapH4,
                Wrap(
                  spacing: AppSizes.p8,
                  runSpacing: AppSizes.p4,
                  children: [
                    Text(formattedDate, style: metaDateStyle),
                    if (transaction.category != null &&
                        transaction.category!.isNotEmpty)
                      Text(
                        '• ${transaction.category}',
                        style: metaDateStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (businessName != null)
                      Text(
                        '• $businessName',
                        style: metaDateStyle?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: details.bubbleColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          details.icon,
                          color: details.bubbleColor,
                          size: 20,
                        ),
                      ),
                      AppSizes.gapW12,
                      Expanded(child: detailWidget),
                    ],
                  ),
                  AppSizes.gapH8,
                  amountWidget,
                ],
              );
            }

            return Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: details.bubbleColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    details.icon,
                    color: details.bubbleColor,
                    size: 20,
                  ),
                ),
                AppSizes.gapW16,
                Expanded(child: detailWidget),
                AppSizes.gapW12,
                amountWidget,
              ],
            );
          },
        ),
      ),
    );
  }

  _TypeDetails _getTransactionDetails(TransactionType type) {
    switch (type) {
      case TransactionType.investment:
        return const _TypeDetails(
          typeName: 'Investment',
          icon: Icons.account_balance,
          bubbleColor: AppColors.primary,
          amountSign: '',
          amountColor: AppColors.primary,
        );
      case TransactionType.additionalInvestment:
        return const _TypeDetails(
          typeName: 'Add. Investment',
          icon: Icons.add_business,
          bubbleColor: AppColors.primary,
          amountSign: '',
          amountColor: AppColors.primary,
        );
      case TransactionType.income:
        return const _TypeDetails(
          typeName: 'Income',
          icon: Icons.monetization_on,
          bubbleColor: AppColors.success,
          amountSign: '+',
          amountColor: AppColors.success,
        );
      case TransactionType.dividend:
        return const _TypeDetails(
          typeName: 'Dividend',
          icon: Icons.pie_chart,
          bubbleColor: AppColors.success,
          amountSign: '+',
          amountColor: AppColors.success,
        );
      case TransactionType.expense:
        return const _TypeDetails(
          typeName: 'Expense',
          icon: Icons.shopping_bag,
          bubbleColor: AppColors.error,
          amountSign: '-',
          amountColor: AppColors.error,
        );
      case TransactionType.withdrawal:
        return const _TypeDetails(
          typeName: 'Withdrawal',
          icon: Icons.arrow_downward,
          bubbleColor: AppColors.error,
          amountSign: '-',
          amountColor: AppColors.error,
        );
      case TransactionType.loan:
        return const _TypeDetails(
          typeName: 'Loan',
          icon: Icons.handshake,
          bubbleColor: AppColors.warning,
          amountSign: '+',
          amountColor: AppColors.warning,
        );
      case TransactionType.loanRepayment:
        return const _TypeDetails(
          typeName: 'Loan Repayment',
          icon: Icons.assignment_turned_in,
          bubbleColor: AppColors.error,
          amountSign: '-',
          amountColor: AppColors.error,
        );
      case TransactionType.assetPurchase:
        return const _TypeDetails(
          typeName: 'Asset Purchase',
          icon: Icons.shopping_cart,
          bubbleColor: AppColors.error,
          amountSign: '-',
          amountColor: AppColors.error,
        );
      case TransactionType.assetSale:
        return const _TypeDetails(
          typeName: 'Asset Sale',
          icon: Icons.sell,
          bubbleColor: AppColors.success,
          amountSign: '+',
          amountColor: AppColors.success,
        );
      case TransactionType.tax:
        return const _TypeDetails(
          typeName: 'Tax',
          icon: Icons.percent,
          bubbleColor: AppColors.error,
          amountSign: '-',
          amountColor: AppColors.error,
        );
      case TransactionType.other:
        return const _TypeDetails(
          typeName: 'Other',
          icon: Icons.info,
          bubbleColor: Colors.blueGrey,
          amountSign: '',
          amountColor: Colors.blueGrey,
        );
    }
  }
}

class _TypeDetails {
  const _TypeDetails({
    required this.typeName,
    required this.icon,
    required this.bubbleColor,
    required this.amountSign,
    required this.amountColor,
  });

  final String typeName;
  final IconData icon;
  final Color bubbleColor;
  final String amountSign;
  final Color amountColor;
}
