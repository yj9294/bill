import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/money_format.dart';
import '../../core/widgets/app_card.dart';
import '../providers/ledger_provider.dart';
import '../widgets/screen_header.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<LedgerProvider>();
    final trend = ledger.weeklyExpenseTrend;
    final categories = ledger.expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ScreenHeader(
            title: 'Analytics',
            subtitle: 'Clear snapshots without sending data anywhere.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Spend',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        MoneyFormat.amount(
                          trend.fold(0, (sum, item) => sum + item),
                        ),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 22),
                      _BarChart(values: trend),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (categories.isEmpty)
                        Text(
                          'No expense data yet. Add records to see local category trends.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.muted),
                        )
                      else
                        for (final item in categories.take(5)) ...[
                          _CategoryStat(
                            name: item.key,
                            amount: item.value,
                            fraction: ledger.expenseTotal == 0
                                ? 0
                                : item.value / ledger.expenseTotal,
                          ),
                          const SizedBox(height: 14),
                        ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<double>(
      1,
      (current, item) => item > current ? item : current,
    );
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final height = 24 + (values[index] / max) * 112;
          final selected = index == values.length - 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                height: height,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryStat extends StatelessWidget {
  const _CategoryStat({
    required this.name,
    required this.amount,
    required this.fraction,
  });

  final String name;
  final double amount;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              MoneyFormat.amount(amount),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 9,
            value: fraction.clamp(0, 1),
            color: AppColors.primary,
            backgroundColor: AppColors.cardSoft,
          ),
        ),
      ],
    );
  }
}
