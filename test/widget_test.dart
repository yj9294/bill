import 'package:bill/app/app.dart';
import 'package:bill/data/datasources/local_bill_store.dart';
import 'package:bill/data/repositories/bill_repository_impl.dart';
import 'package:bill/presentation/providers/ledger_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders the local ledger shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = BillRepositoryImpl(
      localStore: LocalBillStore(preferences),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LedgerProvider(repository)..bootstrap(),
        child: const BillApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Money Flow'), findsOneWidget);
    expect(find.text('Stored locally only'), findsOneWidget);
  });
}
