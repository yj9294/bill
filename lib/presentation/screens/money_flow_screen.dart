import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/category_icon_catalog.dart';
import '../../core/utils/money_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_logo_mark.dart';
import '../../domain/entities/ledger_entry.dart';
import '../providers/ledger_provider.dart';
import '../widgets/amount_delta.dart';
import '../widgets/screen_header.dart';

class MoneyFlowScreen extends StatelessWidget {
  const MoneyFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerProvider>(
      builder: (context, ledger, _) {
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ScreenHeader(
                  title: 'Money Flow',
                  subtitle: 'Your local ledger, refreshed on this device.',
                  action: const AppLogoMark(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.list(
                  children: [
                    _BalanceCard(balance: ledger.balance),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Income',
                            amount: ledger.incomeTotal,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Expenses',
                            amount: ledger.expenseTotal,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(
                      title: 'Recent records',
                      trailing: '${ledger.entries.length} records',
                    ),
                    const SizedBox(height: 12),
                    if (ledger.entries.isEmpty)
                      const _EmptyRecordsCard()
                    else
                      ...ledger.entries
                          .take(5)
                          .map(
                            (entry) => _RecentEntryTile(
                              entry,
                              categoryIconKey: ledger
                                  .categoryByName(entry.category)
                                  ?.icon,
                            ),
                          ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyRecordsCard extends StatelessWidget {
  const _EmptyRecordsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.cardSoft,
      borderColor: AppColors.cardSoft,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.add_card_rounded,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No records yet',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your first income or expense from Record.',
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF49C9D6)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.32),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total balance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            MoneyFormat.amount(balance),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Stored locally only',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              label == 'Income'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            MoneyFormat.amount(amount),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _RecentEntryTile extends StatelessWidget {
  const _RecentEntryTile(this.entry, {this.categoryIconKey});

  final LedgerEntry entry;
  final String? categoryIconKey;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d').format(entry.date);
    final color = entry.isIncome ? AppColors.primary : AppColors.info;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            AppIconBadge(
              icon: categoryIconKey == null
                  ? Icons.category_rounded
                  : CategoryIconCatalog.resolve(categoryIconKey!),
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.category} - $date',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            AmountDelta(amount: entry.amount, type: entry.type),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(
          trailing,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
