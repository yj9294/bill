import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/entities/ledger_entry.dart';

class EntryTypeSwitch extends StatelessWidget {
  const EntryTypeSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.expenseLabel = 'Expense',
    this.incomeLabel = 'Income',
  });

  final EntryType value;
  final ValueChanged<EntryType> onChanged;
  final String expenseLabel;
  final String incomeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _TypeSegment(
            label: expenseLabel,
            selected: value == EntryType.expense,
            onTap: () => onChanged(EntryType.expense),
          ),
          _TypeSegment(
            label: incomeLabel,
            selected: value == EntryType.income,
            onTap: () => onChanged(EntryType.income),
          ),
        ],
      ),
    );
  }
}

class _TypeSegment extends StatelessWidget {
  const _TypeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}
