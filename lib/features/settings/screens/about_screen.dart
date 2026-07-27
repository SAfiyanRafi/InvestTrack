import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.p16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About InvestTrack', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                AppSizes.gapH8,
                Text('A modern finance management app built for offline reliability and future-ready backups.', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          AppSizes.gapH16,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Version', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                AppSizes.gapH8,
                Text(_appVersion, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          AppSizes.gapH16,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Licenses', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                AppSizes.gapH8,
                Text('Open source licenses for InvestTrack components will be shown here in a future update.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
