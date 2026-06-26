import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/spending_category.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/local_bill_store.dart';

class BillRepositoryImpl implements BillRepository {
  const BillRepositoryImpl({required LocalBillStore localStore})
    : _localStore = localStore;

  final LocalBillStore _localStore;

  @override
  Future<List<LedgerEntry>> loadEntries() => _localStore.loadEntries();

  @override
  Future<List<SpendingCategory>> loadCategories() {
    return _localStore.loadCategories();
  }

  @override
  Future<void> saveEntries(List<LedgerEntry> entries) {
    return _localStore.saveEntries(entries);
  }

  @override
  Future<void> saveCategories(List<SpendingCategory> categories) {
    return _localStore.saveCategories(categories);
  }

  @override
  Future<void> clearEntries() => _localStore.clearEntries();

  @override
  Future<void> clearCategories() => _localStore.clearCategories();
}
