import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/isar_database.dart';
import 'core/router/app_router.dart';
import 'core/startup/app_startup_warmup.dart';
import 'core/theme/app_theme.dart';

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
    ref.watch(appStartupWarmupProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'InvestTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically adapts to system light/dark settings
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
