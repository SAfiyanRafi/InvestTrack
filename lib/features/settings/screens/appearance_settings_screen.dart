// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:investtrack/core/constants/app_sizes.dart';
import 'package:investtrack/shared/widgets/app_card.dart';
import 'package:investtrack/features/settings/providers/settings_provider.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  static const _supportedCurrencies = ['PKR', 'USD', 'EUR', 'GBP', 'AED'];
  static const _themeOptions = ['system', 'light', 'dark'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(appSettingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance & Locale')),
      body: asyncSettings.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(AppSizes.p16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  Text(
                    'Choose the theme mode and locale defaults for InvestTrack.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            AppSizes.gapH16,
            AppCard(
              child: Column(
                children: _themeOptions.map((option) {
                  return RadioListTile<String>(
                    value: option,
                    groupValue: settings.themeMode,
                    title: Text(option[0].toUpperCase() + option.substring(1)),
                    subtitle: Text(
                      option == 'system'
                          ? 'Follow system theme'
                          : 'Use ${option[0].toUpperCase() + option.substring(1)} mode',
                    ),
                    onChanged: (value) => value != null
                        ? ref
                              .read(appSettingsNotifierProvider.notifier)
                              .updateThemeMode(value)
                        : null,
                  );
                }).toList(),
              ),
            ),
            AppSizes.gapH16,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Currency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  DropdownButtonFormField<String>(
                    value: settings.currency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _supportedCurrencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .updateCurrency(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            AppSizes.gapH16,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Locale Ready',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapH8,
                  const Text(
                    'Date format, number format, and language selection will be available in the next release.',
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Unable to load preferences: $error')),
      ),
    );
  }
}
