import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/spending_category.dart';

class LocalBillStore {
  const LocalBillStore(this._preferences);

  static const _entriesKey = 'bill.entries.v1';
  static const _categoriesKey = 'bill.categories.v1';

  final SharedPreferences _preferences;

  Future<List<LedgerEntry>> loadEntries() async {
    final raw = _preferences.getString(_entriesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => LedgerEntry.fromJson(item as Map<String, Object?>))
        .toList();
  }

  Future<void> saveEntries(List<LedgerEntry> entries) async {
    final encoded = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await _preferences.setString(_entriesKey, encoded);
  }

  Future<List<SpendingCategory>> loadCategories() async {
    final raw = _preferences.getString(_categoriesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => SpendingCategory.fromJson(item as Map<String, Object?>))
        .toList();
  }

  Future<void> saveCategories(List<SpendingCategory> categories) async {
    final encoded = jsonEncode(
      categories.map((category) => category.toJson()).toList(),
    );
    await _preferences.setString(_categoriesKey, encoded);
  }

  Future<void> clearEntries() async {
    await _preferences.remove(_entriesKey);
  }

  Future<void> clearCategories() async {
    await _preferences.remove(_categoriesKey);
  }
}
