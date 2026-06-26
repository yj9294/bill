import '../entities/ledger_entry.dart';
import '../repositories/bill_repository.dart';

class SaveEntries {
  const SaveEntries(this.repository);

  final BillRepository repository;

  Future<void> call(List<LedgerEntry> entries) {
    return repository.saveEntries(entries);
  }
}
