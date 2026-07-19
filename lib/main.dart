import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/isar_database.dart';
import 'core/router/app_router.dart';
import 'core/services/local_notification_service.dart';
import 'core/startup/app_startup_warmup.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Ensure Flutter engine bindings are fully initialized before async database runs
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local Isar database instance
  final isar = await IsarDatabase.init();
  await LocalNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the initialized database instance
        isarProvider.overrideWithValue(isar),
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
