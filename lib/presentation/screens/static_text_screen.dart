import 'package:flutter/material.dart';

import '../../app/app_info.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_logo_mark.dart';
import '../widgets/screen_header.dart';

class StaticTextScreen extends StatelessWidget {
  const StaticTextScreen.privacyPolicy({super.key})
    : title = 'Privacy Policy',
      subtitle = 'How ${AppInfo.name} handles your data',
      updatedAt = 'Last updated: ${AppInfo.policyLastUpdated}',
      showLogo = false,
      sections = const [
        StaticTextSectionSection(
          heading: 'Overview',
          paragraphs: [
            '${AppInfo.name} is a local-first personal bookkeeping app for recording income, expenses, categories, budgets, and simple summaries directly on your device.',
            'Version ${AppInfo.versionLabel} does not require account registration and does not provide cloud sync for your ledger data.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Information Stored On Your Device',
          paragraphs: [
            'The app stores the records you create, category settings, and related local preferences inside the app sandbox on your device so the app can function properly.',
            'Your bookkeeping content is intended to remain on your device unless you choose to remove the app or clear local data from Settings.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Information We Do Not Collect',
          paragraphs: [
            '${AppInfo.name} does not create user accounts, does not collect your financial records on a remote server, does not use third-party analytics, does not request tracking permission, and does not sell or share your personal data for advertising purposes in the App Store release of the app.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Data Deletion',
          paragraphs: [
            'You can delete your local records at any time by using the `Clear local data` option inside the app Settings page.',
            'If you uninstall ${AppInfo.name}, the app data stored inside the app sandbox is removed by the operating system as part of the uninstall process.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Children\'s Privacy',
          paragraphs: [
            '${AppInfo.name} is not designed to knowingly collect personal information from children because the app does not provide account creation or remote data collection in its current release.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Contact',
          paragraphs: [
            'If you have privacy-related questions about ${AppInfo.name}, please contact support at yjian0152@gmail.com or use the Support page inside the app.',
          ],
        ),
      ];

  const StaticTextScreen.termsOfUse({super.key})
    : title = 'Terms of Use',
      subtitle = 'Basic terms for using ${AppInfo.name}',
      updatedAt = 'Last updated: ${AppInfo.policyLastUpdated}',
      showLogo = false,
      sections = const [
        StaticTextSectionSection(
          heading: 'Acceptance of Terms',
          paragraphs: [
            'By downloading or using ${AppInfo.name}, you agree to these Terms of Use.',
            'If you do not agree with these terms, please stop using the app and remove it from your device.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'App Purpose',
          paragraphs: [
            '${AppInfo.name} is provided as a personal bookkeeping tool for recording and reviewing your own financial information.',
            'The app is offered for general informational and organizational use only and does not provide financial, tax, accounting, investment, or legal advice.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Your Responsibilities',
          paragraphs: [
            'You are responsible for reviewing the information you enter into the app and for deciding how you use any summaries, budgets, or bookkeeping records generated from that information.',
            'You are also responsible for maintaining access to your own device and for protecting any sensitive information visible on that device.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Availability and Changes',
          paragraphs: [
            '${AppInfo.name} may be updated, improved, limited, or discontinued at any time.',
            'Features, interface details, and platform behavior may change between app versions.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'No Warranty',
          paragraphs: [
            '${AppInfo.name} is provided on an "as is" and "as available" basis to the maximum extent permitted by applicable law.',
            'We do not guarantee that the app will always be error-free, uninterrupted, or suitable for every financial workflow.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Limitation of Liability',
          paragraphs: [
            'To the maximum extent permitted by applicable law, the developer of ${AppInfo.name} is not liable for any indirect, incidental, special, consequential, or data-loss related damages resulting from your use of the app.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Contact',
          paragraphs: [
            'If you have questions about these terms, please contact support at yjian0152@gmail.com or use the Support page inside the app.',
          ],
        ),
      ];

  const StaticTextScreen.support({super.key})
    : title = 'Support',
      subtitle = 'Help for ${AppInfo.name}',
      updatedAt = 'Last updated: ${AppInfo.policyLastUpdated}',
      showLogo = true,
      sections = const [
        StaticTextSectionSection(
          heading: 'About Support',
          paragraphs: [
            '${AppInfo.name} is a lightweight local-first bookkeeping app built for simple personal record keeping.',
            'This support page is provided for App Store review and for users who need help understanding how version ${AppInfo.versionLabel} works.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Common Help',
          paragraphs: [
            'Records, categories, and budget-related information are stored locally on the device in the current release.',
            'You can manage categories and clear local data from the Settings page inside the app.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Troubleshooting',
          paragraphs: [
            'If the app does not behave as expected, first close and reopen the app, then verify that your device has enough available storage and is running a supported system version.',
            'If you remove the app or clear local data, locally stored bookkeeping records may no longer be recoverable.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'App Store Review Notes',
          paragraphs: [
            '${AppInfo.name} version ${AppInfo.versionLabel} provides in-app access to the Privacy Policy, Terms of Use, and Support pages from the Settings screen.',
            'The current release is designed for local-only bookkeeping data storage on the user\'s device.',
          ],
        ),
        StaticTextSectionSection(
          heading: 'Contact Support',
          paragraphs: [
            'For support requests, feature suggestions, or privacy and terms questions, please email yjian0152@gmail.com.',
            'You can also keep the same email in the App Store Connect support contact fields for consistency during review.',
          ],
        ),
      ];

  final String title;
  final String subtitle;
  final String updatedAt;
  final bool showLogo;
  final List<StaticTextSectionSection> sections;

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
              leading: const AppBackButton(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (showLogo) ...[
                    const AppLogoMark(size: 88),
                    const SizedBox(height: 18),
                  ],
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          updatedAt,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 18),
                        for (final section in sections) ...[
                          Text(
                            section.heading,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          for (final paragraph in section.paragraphs) ...[
                            Text(
                              paragraph,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.ink,
                                    height: 1.55,
                                  ),
                            ),
                            if (paragraph != section.paragraphs.last)
                              const SizedBox(height: 12),
                          ],
                          if (section != sections.last)
                            const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StaticTextSectionSection {
  const StaticTextSectionSection({
    required this.heading,
    required this.paragraphs,
  });

  final String heading;
  final List<String> paragraphs;
}
