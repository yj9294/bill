import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/entities/ledger_entry.dart';

class AmountDelta extends StatelessWidget {
  const AmountDelta({required this.amount, required this.type, super.key});

  final double amount;
  final EntryType type;

  @override
  Widget build(BuildContext context) {
    final isIncome = type == EntryType.income;
    final color = isIncome ? AppColors.primaryDark : AppColors.danger;
    final prefix = isIncome ? '+' : '-';
    return Text(
      '$prefix\$${amount.toStringAsFixed(2)}',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
