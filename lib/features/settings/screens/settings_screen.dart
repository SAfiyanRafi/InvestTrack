import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.p16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSizes.gapH8,
                Text(
                  'Manage documents, backups, preferences, and system behavior.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          AppSizes.gapH16,
          AppCard(
            padding: EdgeInsets.zero,
            onTap: () => context.push('/settings/appearance'),
            child: const ListTile(
              leading: Icon(Icons.color_lens_outlined),
              title: Text('Appearance & Locale'),
              subtitle: Text('Theme mode, currency, and locale preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          AppSizes.gapH16,
          AppCard(
            padding: EdgeInsets.zero,
            onTap: () => context.push('/settings/about'),
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              subtitle: Text('App version, licenses, and developer info'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          AppSizes.gapH16,
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('Documents & Attachments'),
              subtitle: const Text('Manage business and transaction files'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/documents'),
            ),
          ),
        ],
      ),
    );
  }
}
