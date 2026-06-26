import 'package:flutter/foundation.dart';

import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/spending_category.dart';
import '../../domain/repositories/bill_repository.dart';

class LedgerProvider extends ChangeNotifier {
  LedgerProvider(this._repository);

  final BillRepository _repository;
  final List<LedgerEntry> _entries = [];
  final List<SpendingCategory> _categories = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<LedgerEntry> get entries => List.unmodifiable(_entries);
  List<SpendingCategory> get categories => List.unmodifiable(_categories);

  static const List<SpendingCategory> _defaultCategories = [
    SpendingCategory(
      name: 'Food',
      icon: 'food',
      color: 0xFF55D7B7,
      monthlyLimit: 520,
    ),
    SpendingCategory(
      name: 'Transport',
      icon: 'transport',
      color: 0xFF57C7E8,
      monthlyLimit: 260,
    ),
    SpendingCategory(
      name: 'Shopping',
      icon: 'shopping',
      color: 0xFFFF6B6B,
      monthlyLimit: 420,
    ),
    SpendingCategory(
      name: 'Bills',
      icon: 'bills',
      color: 0xFFFFC857,
      monthlyLimit: 360,
    ),
    SpendingCategory(
      name: 'Health',
      icon: 'health',
      color: 0xFF9B7EDE,
      monthlyLimit: 180,
    ),
    SpendingCategory(
      name: 'Salary',
      icon: 'salary',
      color: 0xFF1F2831,
      monthlyLimit: 0,
      type: EntryType.income,
    ),
  ];

  Future<void> bootstrap() async {
    _isLoading = true;
    notifyListeners();

    final stored = await _repository.loadEntries();
    final storedCategories = await _repository.loadCategories();
    _entries
      ..clear()
      ..addAll(stored);
    _categories
      ..clear()
      ..addAll(
        storedCategories.isEmpty ? _defaultCategories : storedCategories,
      );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry({
    required String title,
    required String category,
    required EntryType type,
    required double amount,
    String note = '',
  }) async {
    final entry = LedgerEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? category : title.trim(),
      category: category,
      type: type,
      amount: amount,
      date: DateTime.now(),
      note: note.trim(),
    );
    _entries.insert(0, entry);
    await _repository.saveEntries(_entries);
    notifyListeners();
  }

  Future<bool> addCategory({
    required String name,
    required EntryType type,
    required String icon,
    required int color,
    double monthlyLimit = 0,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return false;
    }

    final normalizedName = trimmedName.toLowerCase();
    final alreadyExists = _categories.any(
      (category) => category.name.toLowerCase() == normalizedName,
    );
    if (alreadyExists) {
      return false;
    }

    final category = SpendingCategory(
      name: trimmedName,
      icon: icon,
      color: color,
      monthlyLimit: monthlyLimit,
      type: type,
    );

    final firstIncomeIndex = _categories.indexWhere(
      (item) => item.type == EntryType.income,
    );
    if (type == EntryType.expense && firstIncomeIndex >= 0) {
      _categories.insert(firstIncomeIndex, category);
    } else {
      _categories.add(category);
    }

    await _repository.saveCategories(_categories);
    notifyListeners();
    return true;
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _repository.saveEntries(_entries);
    notifyListeners();
  }

  Future<void> clearLocalData() async {
    _entries.clear();
    _categories
      ..clear()
      ..addAll(_defaultCategories);
    await _repository.clearEntries();
    await _repository.clearCategories();
    notifyListeners();
  }

  List<SpendingCategory> categoriesFor(EntryType type) {
    return _categories.where((category) => category.type == type).toList();
  }

  SpendingCategory? categoryByName(String name) {
    for (final category in _categories) {
      if (category.name == name) {
        return category;
      }
    }
    return null;
  }

  double get incomeTotal => _entries
      .where((entry) => entry.type == EntryType.income)
      .fold(0, (sum, entry) => sum + entry.amount);

  double get expenseTotal => _entries
      .where((entry) => entry.type == EntryType.expense)
      .fold(0, (sum, entry) => sum + entry.amount);

  double get balance => incomeTotal - expenseTotal;

  double spentFor(String categoryName) {
    return _entries
        .where(
          (entry) =>
              entry.type == EntryType.expense && entry.category == categoryName,
        )
        .fold(0, (sum, entry) => sum + entry.amount);
  }

  Map<String, double> get expenseByCategory {
    final result = <String, double>{};
    for (final entry in _entries.where(
      (item) => item.type == EntryType.expense,
    )) {
      result[entry.category] = (result[entry.category] ?? 0) + entry.amount;
    }
    return result;
  }

  List<double> get weeklyExpenseTrend {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day - (6 - index));
      return _entries
          .where(
            (entry) =>
                entry.type == EntryType.expense &&
                entry.date.year == day.year &&
                entry.date.month == day.month &&
                entry.date.day == day.day,
          )
          .fold(0, (sum, entry) => sum + entry.amount);
    });
  }
}
