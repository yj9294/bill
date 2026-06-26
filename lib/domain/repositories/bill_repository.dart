import '../entities/ledger_entry.dart';
import '../entities/spending_category.dart';

abstract interface class BillRepository {
  Future<List<LedgerEntry>> loadEntries();
  Future<List<SpendingCategory>> loadCategories();
  Future<void> saveEntries(List<LedgerEntry> entries);
  Future<void> saveCategories(List<SpendingCategory> categories);
  Future<void> clearEntries();
  Future<void> clearCategories();
}
