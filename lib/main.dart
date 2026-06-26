import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'data/datasources/local_bill_store.dart';
import 'data/repositories/bill_repository_impl.dart';
import 'presentation/providers/ledger_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final repository = BillRepositoryImpl(
    localStore: LocalBillStore(preferences),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LedgerProvider(repository)..bootstrap(),
        ),
      ],
      child: const BillApp(),
    ),
  );
}
