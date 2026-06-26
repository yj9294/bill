import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/category_icon_catalog.dart';
import '../../core/utils/money_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../providers/ledger_provider.dart';
import '../widgets/screen_header.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<LedgerProvider>();
    final budgetCategories = ledger.categories
        .where((category) => category.monthlyLimit > 0)
        .toList();
    final totalLimit = budgetCategories.fold<double>(
      0,
      (sum, category) => sum + category.monthlyLimit,
    );
    final totalSpent = budgetCategories.fold<double>(
      0,
      (sum, category) => sum + ledger.spentFor(category.name),
    );

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ScreenHeader(
            title: 'Budget',
            subtitle: 'Monthly limits for everyday spending.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                AppCard(
                  color: AppColors.ink,
                  borderColor: AppColors.ink,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget used',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        MoneyFormat.amount(totalSpent),
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: totalLimit == 0
                              ? 0
                              : (totalSpent / totalLimit).clamp(0, 1),
                          color: AppColors.primary,
                          backgroundColor: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (final category in budgetCategories) ...[
                  _BudgetTile(
                    label: category.name,
                    iconKey: category.icon,
                    color: Color(category.color),
                    spent: ledger.spentFor(category.name),
                    limit: category.monthlyLimit,
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({
    required this.label,
    required this.iconKey,
    required this.color,
    required this.spent,
    required this.limit,
  });

  final String label;
  final String iconKey;
  final Color color;
  final double spent;
  final double limit;

  @override
  Widget build(BuildContext context) {
    final fraction = limit == 0 ? 0.0 : (spent / limit).clamp(0.0, 1.0);
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          AppIconBadge(
            icon: CategoryIconCatalog.resolve(iconKey),
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      '${(fraction * 100).round()}%',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: fraction,
                    color: color,
                    backgroundColor: AppColors.cardSoft,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${MoneyFormat.amount(spent)} of ${MoneyFormat.amount(limit)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
