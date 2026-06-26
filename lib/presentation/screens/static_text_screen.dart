import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_logo_mark.dart';
import '../widgets/screen_header.dart';

class StaticTextScreen extends StatelessWidget {
  const StaticTextScreen.policy({super.key})
    : title = 'Policy',
      subtitle = 'Policy and data use',
      paragraphs = const [
        'Pure Ledger is a local-first bookkeeping app. Records are saved on this device so you can review income, expenses, categories, budgets, and simple summaries.',
        'The app does not create an account, use cloud sync, provide subscriptions, offer in-app purchases, request tracking permission, collect advertising identifiers, upload financial records, or share ledger content with third parties.',
        'If you delete the app, iOS or Android removes the app sandbox and the local ledger data stored by Pure Ledger.',
      ];

  const StaticTextScreen.about({super.key})
    : title = 'About',
      subtitle = 'App information',
      paragraphs = const [
        'Pure Ledger is a lightweight personal bookkeeping app designed for quick entries, calm summaries, and simple monthly budgeting.',
        'Version 1.0.0',
        'Built for iOS and Android with Flutter. The current build keeps data local and avoids network accounts, cloud sync, analytics, subscriptions, and in-app purchases.',
      ];

  final String title;
  final String subtitle;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ScreenHeader(
              title: title,
              subtitle: subtitle,
              action: const AppBackButton(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (title == 'About') ...[
                    const AppLogoMark(size: 88),
                    const SizedBox(height: 18),
                  ],
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final paragraph in paragraphs) ...[
                          Text(
                            paragraph,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.ink, height: 1.55),
                          ),
                          if (paragraph != paragraphs.last)
                            const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
