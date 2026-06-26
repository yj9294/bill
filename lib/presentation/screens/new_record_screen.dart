import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/ads/rewarded_record_ad_gate.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_loading_dialog.dart';
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
  bool _isSubmitting = false;

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
                  label: _isSubmitting ? 'Unlocking...' : 'Save Record',
                  icon: Icons.check_rounded,
                  onPressed:
                      _isSubmitting ||
                          amount == null ||
                          amount <= 0 ||
                          categories.isEmpty
                      ? null
                      : () async {
                          await _handleSaveRecord(
                            amount: amount,
                            category: selectedCategory,
                            fallbackCategory: categories.first.name,
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSaveRecord({
    required double amount,
    required String category,
    required String fallbackCategory,
  }) async {
    setState(() => _isSubmitting = true);

    try {
      final rewardedAdGate = context.read<RewardedRecordAdGate>();
      final unlocked = await _unlockRecordSaveIfNeeded(rewardedAdGate);
      if (!unlocked || !mounted) {
        return;
      }

      await context.read<LedgerProvider>().addEntry(
        title: _titleController.text,
        category: category,
        type: _type,
        amount: amount,
        note: _noteController.text,
      );
      _titleController.clear();
      _amountController.clear();
      _noteController.clear();
      if (!mounted) {
        return;
      }

      AppToast.show(
        context,
        title: 'Record saved',
        message:
            '$category ${_type == EntryType.income ? 'income' : 'expense'} added locally.',
      );
      setState(() {
        _category = fallbackCategory;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<bool> _unlockRecordSaveIfNeeded(
    RewardedRecordAdGate rewardedAdGate,
  ) async {
    if (!rewardedAdGate.shouldShowAdBeforeNextRecord) {
      rewardedAdGate.markRecordSavedWithoutAd();
      return true;
    }

    await AppLoadingDialog.show(
      context,
      title: 'Loading rewarded ad',
      message: 'A short test ad is required before this record is saved.',
    );

    var loadingVisible = true;

    try {
      final outcome = await rewardedAdGate.loadRewardedAdForRecord();
      if (!mounted) {
        return false;
      }

      AppLoadingDialog.hide(context);
      loadingVisible = false;

      switch (outcome.status) {
        case RewardedAdLoadStatus.loaded:
          final ad = outcome.ad!;
          final rewardEarned = await rewardedAdGate.showRewardedAd(ad);
          if (!mounted) {
            return false;
          }

          if (!rewardEarned) {
            AppToast.show(
              context,
              title: 'Reward not completed',
              message: 'Finish the rewarded ad to continue saving this record.',
              tone: AppToastTone.warning,
            );
            return false;
          }

          rewardedAdGate.markRecordSavedAfterReward();
          return true;
        case RewardedAdLoadStatus.disabled:
          rewardedAdGate.markRecordSavedWithoutAd();
          return true;
        case RewardedAdLoadStatus.noNetwork:
          AppToast.show(
            context,
            title: 'Network required',
            message:
                'Connect to the internet before requesting the rewarded ad.',
            tone: AppToastTone.warning,
          );
          return false;
        case RewardedAdLoadStatus.failed:
          AppToast.show(
            context,
            title: 'Ad failed to load',
            message: 'The rewarded test ad did not load. Please try again.',
            tone: AppToastTone.warning,
          );
          return false;
      }
    } finally {
      if (loadingVisible && mounted) {
        AppLoadingDialog.hide(context);
      }
    }
  }
}
