import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    this.label,
    this.icon,
    this.color = AppColors.primary,
    this.size = 40,
  });

  final String? label;
  final IconData? icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(size * 0.38),
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, color: color, size: size * 0.5)
          : Text(
              label ?? '',
              style: TextStyle(
                color: color,
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
    );
  }
}
