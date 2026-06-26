import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_toast.dart';
import '../../domain/entities/ledger_entry.dart';
import '../providers/ledger_provider.dart';
import '../widgets/entry_type_switch.dart';
import '../widgets/screen_header.dart';

class NewRecordScreen extends StatefulWidget {
  const NewRecordScreen({super.key});

  @override
  State<NewRecordScreen> createState() => _NewRecordScreenState();
}

class _NewRecordScreenState extends State<NewRecordScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  EntryType _type = EntryType.expense;
  String _category = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<LedgerProvider>();
    final categories = ledger.categoriesFor(_type);
    final selectedCategory =
        categories.any((category) => category.name == _category)
        ? _category
        : (categories.isNotEmpty ? categories.first.name : '');
    final amount = double.tryParse(_amountController.text);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ScreenHeader(
            title: 'New Record',
            subtitle: 'A quick entry flow inspired by the Figma sheet.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                AppCard(
                  child: Column(
                    children: [
                      EntryTypeSwitch(
                        value: _type,
                        onChanged: (type) {
                          final nextCategories = ledger.categoriesFor(type);
                          setState(() {
                            _type = type;
                            _category = nextCategories.isNotEmpty
                                ? nextCategories.first.name
                                : '';
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                        decoration: const InputDecoration(
                          hintText: r'$ 0.00',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Lunch, salary, groceries...',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Optional local note',
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    final selected = category.name == selectedCategory;
                    return ChoiceChip(
                      label: Text(category.name),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppColors.primary.withValues(alpha: 0.22),
                      backgroundColor: AppColors.card,
                      side: BorderSide(
                        color: selected ? AppColors.primary : AppColors.line,
                      ),
                      labelStyle: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(
                            color: selected
                                ? AppColors.primaryDark
                                : AppColors.ink,
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (_) =>
                          setState(() => _category = category.name),
                    );
                  }).toList(),
                ),
                if (categories.isEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _type == EntryType.expense
                          ? 'Add an expense category from Settings before saving.'
                          : 'Add an income category from Settings before saving.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Save Record',
                  icon: Icons.check_rounded,
                  onPressed: amount == null || amount <= 0 || categories.isEmpty
                      ? null
                      : () async {
                          await context.read<LedgerProvider>().addEntry(
                            title: _titleController.text,
                            category: selectedCategory,
                            type: _type,
                            amount: amount,
                            note: _noteController.text,
                          );
                          _titleController.clear();
                          _amountController.clear();
                          _noteController.clear();
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              title: 'Record saved',
                              message:
                                  '$selectedCategory ${_type == EntryType.income ? 'income' : 'expense'} added locally.',
                            );
                            setState(() {
                              _category = categories.first.name;
                            });
                          }
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
