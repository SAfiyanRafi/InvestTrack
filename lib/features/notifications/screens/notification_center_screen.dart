import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../models/app_notification.dart';
import '../models/reminder.dart';
import '../providers/notification_provider.dart';
import '../providers/reminder_provider.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => ref.read(reminderDueSyncProvider));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(notificationFilterProvider);
    final filterNotifier = ref.read(notificationFilterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Reminders'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              final repo = ref.read(notificationRepositoryProvider);
              switch (value) {
                case 'mark_all_read':
                  await repo.markAllAsRead();
                  return;
                case 'clear_read':
                  await repo.clearReadNotifications();
                  return;
                case 'delete_all':
                  await repo.deleteAllNotifications();
                  return;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Mark All Read'),
              ),
              PopupMenuItem(
                value: 'clear_read',
                child: Text('Clear Read'),
              ),
              PopupMenuItem(
                value: 'delete_all',
                child: Text('Delete All'),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.p16,
                  AppSizes.p12,
                  AppSizes.p16,
                  AppSizes.p8,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notifications...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              filterNotifier.setQuery('');
                            },
                          ),
                  ),
                  onChanged: filterNotifier.setQuery,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Wrap(
                  spacing: AppSizes.p8,
                  runSpacing: AppSizes.p8,
                  children: [
                    FilterChip(
                      selected: filter.unreadOnly,
                      label: const Text('Unread Only'),
                      onSelected: filterNotifier.setUnreadOnly,
                    ),
                    ChoiceChip(
                      selected: filter.category == null,
                      label: const Text('All Categories'),
                      onSelected: (_) => filterNotifier.setCategory(null),
                    ),
                    ...NotificationCategory.values.map((category) {
                      return ChoiceChip(
                        selected: filter.category == category,
                        label: Text(_enumLabel(category.name)),
                        onSelected: (_) => filterNotifier.setCategory(category),
                      );
                    }),
                  ],
                ),
              ),
              AppSizes.gapH12,
              Expanded(child: _buildNotificationsList()),
            ],
          ),
          _buildRemindersList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/reminders/new'),
        icon: const Icon(Icons.alarm_add_outlined),
        label: const Text('New Reminder'),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final asyncNotifications = ref.watch(filteredNotificationsProvider);

    return asyncNotifications.when(
      loading: () => const AppLoader(message: 'Loading notifications...'),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (notifications) {
        if (notifications.isEmpty) {
          return const _EmptyBlock(
            icon: Icons.notifications_none_outlined,
            title: 'No notifications',
            subtitle: 'Important updates and reminders will appear here.',
          );
        }

        final sections = _groupByDate(notifications);
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.p16),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppSizes.gapH8,
                  ...section.items.map(_buildNotificationCard),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    final repo = ref.read(notificationRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p8),
      child: Dismissible(
        key: ValueKey('notification-${notification.id}'),
        background: _dismissBackground(AppColors.warning, Icons.archive_outlined),
        secondaryBackground:
            _dismissBackground(AppColors.error, Icons.delete_outline),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await repo.archiveNotification(notification.id);
            return true;
          }
          if (direction == DismissDirection.endToStart) {
            await repo.deleteNotification(notification.id);
            return true;
          }
          return false;
        },
        child: AppCard(
          child: InkWell(
            onTap: () async {
              if (!notification.isRead) {
                await repo.markAsRead(notification.id);
              }

              final route = notification.actionRoute;
              if (route != null && route.isNotEmpty && mounted) {
                await context.push(route);
              }
            },
            borderRadius: BorderRadius.circular(AppSizes.r16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _typeColor(notification.type).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSizes.r8),
                      ),
                      child: Icon(
                        _categoryIcon(notification.category),
                        size: 18,
                        color: _typeColor(notification.type),
                      ),
                    ),
                    AppSizes.gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                          ),
                          AppSizes.gapH4,
                          Text(notification.body),
                          AppSizes.gapH4,
                          Text(
                            _relativeTime(notification.timestamp),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'pin':
                            await repo.pinNotification(notification.id, !notification.pinned);
                            return;
                          case 'mark_read':
                            await repo.markAsRead(notification.id);
                            return;
                          case 'archive':
                            await repo.archiveNotification(notification.id);
                            return;
                          case 'delete':
                            await repo.deleteNotification(notification.id);
                            return;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'pin',
                          child: Text(notification.pinned ? 'Unpin' : 'Pin'),
                        ),
                        const PopupMenuItem(
                          value: 'mark_read',
                          child: Text('Mark Read'),
                        ),
                        const PopupMenuItem(
                          value: 'archive',
                          child: Text('Archive'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                if (notification.category == NotificationCategory.reminder &&
                    notification.relatedReminderId != null) ...[
                  AppSizes.gapH12,
                  Wrap(
                    spacing: AppSizes.p8,
                    runSpacing: AppSizes.p8,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          await context.push('/reminders/${notification.relatedReminderId}/edit');
                        },
                        child: const Text('Open'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final reminders =
                              ref.read(activeRemindersProvider).valueOrNull ??
                                  const <Reminder>[];
                          final target = reminders
                              .where((r) => r.id == notification.relatedReminderId)
                              .cast<Reminder?>()
                              .firstWhere(
                                (item) => item != null,
                                orElse: () => null,
                              );
                          if (target == null) {
                            return;
                          }
                          await ref.read(reminderManagerProvider).rescheduleReminder(
                                target,
                                target.dueDate.add(const Duration(days: 1)),
                              );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reminder snoozed by 1 day.')),
                            );
                          }
                        },
                        child: const Text('Snooze'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await repo.archiveNotification(notification.id);
                        },
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersList() {
    final asyncBuckets = ref.watch(reminderStatusBucketsProvider);

    return asyncBuckets.when(
      loading: () => const AppLoader(message: 'Loading reminders...'),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (buckets) {
        final totalCount = buckets.today.length +
            buckets.upcoming.length +
            buckets.overdue.length +
            buckets.completed.length;

        if (totalCount == 0) {
          return const _EmptyBlock(
            icon: Icons.alarm_off_outlined,
            title: 'No reminders',
            subtitle: 'Create reminders for taxes, reviews, and deadlines.',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSizes.p16),
          children: [
            Wrap(
              spacing: AppSizes.p8,
              runSpacing: AppSizes.p8,
              children: [
                _countChip('Today', buckets.today.length, AppColors.primary),
                _countChip('Upcoming', buckets.upcoming.length, AppColors.success),
                _countChip('Overdue', buckets.overdue.length, AppColors.error),
                _countChip('Completed', buckets.completed.length, AppColors.secondary),
              ],
            ),
            AppSizes.gapH16,
            if (buckets.today.isNotEmpty)
              _buildReminderSection('Today', buckets.today),
            if (buckets.upcoming.isNotEmpty)
              _buildReminderSection('Upcoming', buckets.upcoming),
            if (buckets.overdue.isNotEmpty)
              _buildReminderSection('Overdue', buckets.overdue),
            if (buckets.completed.isNotEmpty)
              _buildReminderSection('Completed', buckets.completed),
          ],
        );
      },
    );
  }

  Widget _countChip(String label, int count, Color color) {
    return Chip(
      label: Text('$label ($count)'),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildReminderSection(String label, List<Reminder> reminders) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          AppSizes.gapH12,
          for (final reminder in reminders)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.p12),
              child: _buildReminderCard(reminder),
            ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    final manager = ref.read(reminderManagerProvider);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        onTap: () async {
          await context.push('/reminders/${reminder.id}/edit');
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 44,
                decoration: BoxDecoration(
                  color: _priorityColor(reminder.priority),
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
              ),
              AppSizes.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (reminder.description != null && reminder.description!.isNotEmpty) ...[
                      AppSizes.gapH4,
                      Text(reminder.description!),
                    ],
                    AppSizes.gapH4,
                    Text(
                      '${DateFormat('d MMM y, h:mm a').format(reminder.dueDate)}  •  ${_enumLabel(reminder.priority.name)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'complete':
                      await manager.completeReminder(reminder);
                      return;
                    case 'dismiss':
                      await manager.dismissReminder(reminder);
                      return;
                    case 'reschedule':
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: reminder.dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate == null || !mounted) {
                        return;
                      }
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(reminder.dueDate),
                      );
                      if (pickedTime == null || !mounted) {
                        return;
                      }
                      final newDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      await manager.rescheduleReminder(reminder, newDate);
                      return;
                    case 'duplicate':
                      await manager.duplicateReminder(reminder);
                      return;
                    case 'archive':
                      await manager.archiveReminder(reminder);
                      return;
                    case 'edit':
                      if (mounted) {
                        await context.push('/reminders/${reminder.id}/edit');
                      }
                      return;
                    case 'delete':
                      await manager.deleteReminder(reminder.id);
                      return;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'complete', child: Text('Complete')),
                  PopupMenuItem(value: 'dismiss', child: Text('Dismiss')),
                  PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
                  PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  PopupMenuItem(value: 'archive', child: Text('Archive')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_NotificationSection> _groupByDate(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <AppNotification>[];
    final yesterdayItems = <AppNotification>[];
    final earlierItems = <AppNotification>[];

    for (final item in notifications) {
      final date = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
      if (date == today) {
        todayItems.add(item);
      } else if (date == yesterday) {
        yesterdayItems.add(item);
      } else {
        earlierItems.add(item);
      }
    }

    final sections = <_NotificationSection>[];
    if (todayItems.isNotEmpty) {
      sections.add(_NotificationSection('Today', todayItems));
    }
    if (yesterdayItems.isNotEmpty) {
      sections.add(_NotificationSection('Yesterday', yesterdayItems));
    }
    if (earlierItems.isNotEmpty) {
      sections.add(_NotificationSection('Earlier', earlierItems));
    }

    return sections;
  }

  String _relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) {
      return 'Just now';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    return DateFormat('d MMM y').format(dateTime);
  }

  String _enumLabel(String value) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final parts = value.split(regex);
    return parts
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  Widget _dismissBackground(Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      alignment: Alignment.centerLeft,
      child: Icon(icon, color: color),
    );
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.informational:
        return AppColors.primary;
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.critical:
        return AppColors.error;
    }
  }

  Color _priorityColor(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.low:
        return AppColors.secondary;
      case ReminderPriority.medium:
        return AppColors.primary;
      case ReminderPriority.high:
        return AppColors.warning;
      case ReminderPriority.critical:
        return AppColors.error;
    }
  }

  IconData _categoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.financial:
        return Icons.paid_outlined;
      case NotificationCategory.business:
        return Icons.business_outlined;
      case NotificationCategory.reports:
        return Icons.summarize_outlined;
      case NotificationCategory.documents:
        return Icons.folder_copy_outlined;
      case NotificationCategory.reminder:
        return Icons.alarm_outlined;
      case NotificationCategory.system:
        return Icons.settings_suggest_outlined;
    }
  }
}

class _NotificationSection {
  const _NotificationSection(this.label, this.items);

  final String label;
  final List<AppNotification> items;
}

class _EmptyBlock extends StatelessWidget {
  const _EmptyBlock({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.outline),
            AppSizes.gapH16,
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSizes.gapH8,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
