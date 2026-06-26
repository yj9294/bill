import '../entities/ledger_entry.dart';
import '../repositories/bill_repository.dart';

class LoadEntries {
  const LoadEntries(this.repository);

  final BillRepository repository;

  Future<List<LedgerEntry>> call() => repository.loadEntries();
}
