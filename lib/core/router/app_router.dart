import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/businesses/screens/businesses_list_screen.dart';
import '../../features/businesses/screens/add_edit_business_screen.dart';
import '../../features/businesses/screens/business_details_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/notifications/models/reminder.dart';
import '../../features/notifications/screens/add_edit_reminder_screen.dart';
import '../../features/notifications/screens/notification_center_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/transactions/screens/transactions_screen.dart';
import '../../features/transactions/screens/add_edit_transaction_screen.dart';
import 'main_navigation_scaffold.dart';

// Navigator keys for routing context
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _dashboardNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _businessesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'businesses');
final _transactionsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'transactions');
final _analyticsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'analytics');
final _reportsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'reports');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// Riverpod provider containing the GoRouter configuration.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Tab Branch
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Businesses Tab Branch
          StatefulShellBranch(
            navigatorKey: _businessesNavigatorKey,
            routes: [
              GoRoute(
                path: '/businesses',
                builder: (context, state) => const BusinessesListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AddEditBusinessScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const _RouteParamErrorScreen(
                          message: 'Invalid business id in route.',
                        );
                      }
                      return BusinessDetailsScreen(businessId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final id = int.tryParse(state.pathParameters['id'] ?? '');
                          if (id == null) {
                            return const _RouteParamErrorScreen(
                              message: 'Invalid business id in route.',
                            );
                          }
                          return AddEditBusinessScreen(businessId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Transactions Tab Branch
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final businessIdStr = state.uri.queryParameters['businessId'];
                      final businessId = businessIdStr != null ? int.tryParse(businessIdStr) : null;
                      return AddEditTransactionScreen(businessId: businessId);
                    },
                  ),
                  GoRoute(
                    path: ':id/edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const _RouteParamErrorScreen(
                          message: 'Invalid transaction id in route.',
                        );
                      }
                      return AddEditTransactionScreen(transactionId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Analytics Tab Branch
          StatefulShellBranch(
            navigatorKey: _analyticsNavigatorKey,
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          // Reports Tab Branch
          StatefulShellBranch(
            navigatorKey: _reportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          // Settings Tab Branch
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'documents',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const DocumentsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: '/reminders/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final businessId = int.tryParse(state.uri.queryParameters['businessId'] ?? '');
          final transactionId = int.tryParse(state.uri.queryParameters['transactionId'] ?? '');
          final categoryRaw = state.uri.queryParameters['category'];

          ReminderCategory? category;
          if (categoryRaw != null) {
            for (final value in ReminderCategory.values) {
              if (value.name == categoryRaw) {
                category = value;
                break;
              }
            }
          }

          return AddEditReminderScreen(
            prefillBusinessId: businessId,
            prefillTransactionId: transactionId,
            prefillCategory: category,
          );
        },
      ),
      GoRoute(
        path: '/reminders/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const _RouteParamErrorScreen(
              message: 'Invalid reminder id in route.',
            );
          }
          return AddEditReminderScreen(reminderId: id);
        },
      ),
    ],
  );
});

class _RouteParamErrorScreen extends StatelessWidget {
  const _RouteParamErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
