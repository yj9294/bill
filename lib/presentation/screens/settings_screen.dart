import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_info.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_toast.dart';
import '../providers/ledger_provider.dart';
import '../widgets/screen_header.dart';
import 'categories_screen.dart';
import 'static_text_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ScreenHeader(
            title: 'Settings',
            subtitle: 'Local preferences and app information.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.category_rounded,
                        title: 'Categories',
                        subtitle: 'Manage local groups used by Record',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        ),
                      ),
                      const _DividerInset(),
                      _SettingsRow(
                        icon: Icons.policy_rounded,
                        title: 'Privacy Policy',
                        subtitle: 'How your data is handled in Pure Ledger',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const StaticTextScreen.privacyPolicy(),
                          ),
                        ),
                      ),
                      const _DividerInset(),
                      _SettingsRow(
                        icon: Icons.description_rounded,
                        title: 'Terms of Use',
                        subtitle: 'Conditions for using the app',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StaticTextScreen.termsOfUse(),
                          ),
                        ),
                      ),
                      const _DividerInset(),
                      _SettingsRow(
                        icon: Icons.support_agent_rounded,
                        title: 'Support',
                        subtitle: 'Help, troubleshooting, and contact notes',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StaticTextScreen.support(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppCard(
                  color: AppColors.cardSoft,
                  borderColor: AppColors.cardSoft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppInfo.name} ${AppInfo.versionLabel}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppInfo.name} stores records and categories on this device in the current release. It does not require account sign-in or cloud sync for normal use.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This Settings section includes the Privacy Policy, Terms of Use, and Support pages required for App Store review.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () => _confirmClearLocalData(context),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Clear local data'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearLocalData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear local data?'),
          content: const Text(
            'This removes local records and custom categories saved on this device. There is no cloud copy to restore from.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await context.read<LedgerProvider>().clearLocalData();
      if (context.mounted) {
        AppToast.show(
          context,
          title: 'Local data cleared',
          message: 'Records were removed and categories reset to defaults.',
        );
      }
    }
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _DividerInset extends StatelessWidget {
  const _DividerInset();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 70, color: AppColors.line);
  }
}
