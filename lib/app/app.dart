import 'package:flutter/material.dart';

import '../presentation/screens/home_shell.dart';
import 'theme/app_theme.dart';

class BillApp extends StatelessWidget {
  const BillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Ledger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}
