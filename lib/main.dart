import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/isar_database.dart';
import 'core/router/app_router.dart';
import 'core/startup/app_startup_warmup.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/currency_formatter.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  // Ensure Flutter engine bindings are fully initialized before async database runs
  WidgetsFlutterBinding.ensureInitialized();

  final startupResult = await initializeAppStartup();

  runApp(
    ProviderScope(
      overrides: [
        if (startupResult.isar != null)
          // Inject the initialized database instance when available.
          isarProvider.overrideWithValue(startupResult.isar!),
      ],
      child: const InvestTrackApp(),
    ),
  );
}

/// The root application widget of InvestTrack.
class InvestTrackApp extends ConsumerWidget {
  const InvestTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(appStartupWarmupProvider);
    final settingsState = ref.watch(appSettingsNotifierProvider);

    return startupState.when(
      data: (_) {
        final router = ref.watch(appRouterProvider);
        final themeMode = settingsState.when(
          data: (settings) {
            CurrencyFormatter.updateCurrency(settings.currency);
            return _themeModeFromString(settings.themeMode);
          },
          loading: () => ThemeMode.system,
          error: (_, __) => ThemeMode.system,
        );

        return MaterialApp.router(
          title: 'InvestTrack',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          themeAnimationDuration: Duration.zero,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
      loading: () => const MaterialApp(
        title: 'InvestTrack',
        debugShowCheckedModeBanner: false,
        home: StartupSplashScreen(),
      ),
      error: (_, __) => const MaterialApp(
        title: 'InvestTrack',
        debugShowCheckedModeBanner: false,
        home: StartupSplashScreen(),
      ),
    );
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

class StartupSplashScreen extends StatelessWidget {
  const StartupSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/branding/splash_investtrack.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  '© 2026 Safiyan.co. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
