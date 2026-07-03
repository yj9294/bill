import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/network_notice_service.dart';
import '../presentation/screens/home_shell.dart';
import 'theme/app_theme.dart';

class BillApp extends StatelessWidget {
  const BillApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkNoticeService = context.read<NetworkNoticeService?>();
    return MaterialApp(
      title: 'Pure Ledger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeShell(networkNoticeService: networkNoticeService),
    );
  }
}
