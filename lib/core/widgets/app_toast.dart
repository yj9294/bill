import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum AppToastTone { success, warning }

abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    AppToastTone tone = AppToastTone.success,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: EdgeInsets.zero,
          duration: const Duration(milliseconds: 2200),
          content: _ToastCard(title: title, message: message, tone: tone),
        ),
      );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.title,
    required this.message,
    required this.tone,
  });

  final String title;
  final String? message;
  final AppToastTone tone;

  @override
  Widget build(BuildContext context) {
    final accent = switch (tone) {
      AppToastTone.success => AppColors.primaryDark,
      AppToastTone.warning => AppColors.warning,
    };

    final icon = switch (tone) {
      AppToastTone.success => Icons.check_rounded,
      AppToastTone.warning => Icons.info_outline_rounded,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                if (message != null && message!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
