import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        fixedSize: const Size.square(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.chevron_left_rounded, size: 26),
    );
  }
}
