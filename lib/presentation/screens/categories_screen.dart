import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/category_icon_catalog.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_toast.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/spending_category.dart';
import '../providers/ledger_provider.dart';
import '../widgets/entry_type_switch.dart';
import '../widgets/screen_header.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<LedgerProvider>();
    final expenseCategories = ledger.categoriesFor(EntryType.expense);
    final incomeCategories = ledger.categoriesFor(EntryType.income);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ScreenHeader(
              title: 'Categories',
              subtitle: 'Local groups used by records and budgets.',
              leading: const AppBackButton(),
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AddCategoryButton(
                    onPressed: () => _openAddCategorySheet(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategorySection(
                    title: 'Expense groups',
                    subtitle: '${expenseCategories.length} available in Record',
                    categories: expenseCategories,
                  ),
                  const SizedBox(height: 18),
                  _CategorySection(
                    title: 'Income groups',
                    subtitle: '${incomeCategories.length} available in Record',
                    categories: incomeCategories,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddCategorySheet(BuildContext context) async {
    final created = await showModalBottomSheet<SpendingCategory>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddCategorySheet(),
    );

    if (created != null && context.mounted) {
      AppToast.show(
        context,
        title: 'Category created',
        message: '${created.name} is ready in Record.',
      );
    }
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.subtitle,
    required this.categories,
  });

  final String title;
  final String subtitle;
  final List<SpendingCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 12),
        for (final category in categories) ...[
          AppCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                AppIconBadge(
                  icon: CategoryIconCatalog.resolve(category.icon),
                  color: Color(category.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  category.type == EntryType.income
                      ? 'Income'
                      : category.monthlyLimit > 0
                      ? 'Limit \$${category.monthlyLimit.toStringAsFixed(0)}'
                      : 'No limit',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add category',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.darkButton,
        foregroundColor: Colors.white,
        fixedSize: const Size.square(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded, size: 22),
    );
  }
}

class _AddCategorySheet extends StatefulWidget {
  const _AddCategorySheet();

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  static const _colorOptions = [
    AppColors.primary,
    AppColors.info,
    AppColors.danger,
    AppColors.warning,
    AppColors.violet,
  ];

  final _nameController = TextEditingController();
  final _limitController = TextEditingController();
  EntryType _type = EntryType.expense;
  String _selectedIconKey = CategoryIconCatalog.options.first.key;
  Color _selectedColor = AppColors.primary;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottomInset + 12),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: AppCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'New category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Create a local category for future records.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 18),
              EntryTypeSwitch(
                value: _type,
                onChanged: (type) => setState(() => _type = type),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Category name',
                  hintText: 'Coffee, Bonus, Taxi...',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              Text('Icon', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: CategoryIconCatalog.options.map((option) {
                  final selected = option.key == _selectedIconKey;
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => _selectedIconKey = option.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _selectedColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? _selectedColor : AppColors.line,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        option.icon,
                        color: selected ? _selectedColor : AppColors.muted,
                        size: 22,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Text(
                'Accent color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _colorOptions.map((color) {
                  final selected = color == _selectedColor;
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => _selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? color : AppColors.line,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: selected
                          ? Icon(Icons.check_rounded, color: color, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              if (_type == EntryType.expense) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monthly limit',
                    hintText: 'Optional budget amount',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              AppPrimaryButton(
                label: _isSaving ? 'Saving...' : 'Create category',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _isSaving || _nameController.text.trim().isEmpty
                    ? null
                    : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _save() async {
    final limit = double.tryParse(_limitController.text.trim()) ?? 0;

    setState(() => _isSaving = true);
    final created = await context.read<LedgerProvider>().addCategory(
      name: _nameController.text,
      type: _type,
      icon: _selectedIconKey,
      color: _selectedColor.toARGB32(),
      monthlyLimit: _type == EntryType.expense ? limit : 0,
    );
    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (!created) {
      AppToast.show(
        context,
        title: 'Category already exists',
        message: 'Choose a different name to keep records unambiguous.',
        tone: AppToastTone.warning,
      );
      return;
    }

    Navigator.of(context).pop(
      SpendingCategory(
        name: _nameController.text.trim(),
        icon: _selectedIconKey,
        color: _selectedColor.toARGB32(),
        monthlyLimit: _type == EntryType.expense ? limit : 0,
        type: _type,
      ),
    );
  }
}
