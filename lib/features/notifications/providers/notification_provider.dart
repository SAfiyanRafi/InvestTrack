import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_database.dart';
import '../models/app_notification.dart';
import '../repositories/isar_notification_repository.dart';
import '../repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarNotificationRepository(isar);
});

final watchNotificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.watchNotifications();
});

class NotificationFilterState {
  const NotificationFilterState({
    this.query = '',
    this.category,
    this.unreadOnly = false,
  });

  final String query;
  final NotificationCategory? category;
  final bool unreadOnly;

  NotificationFilterState copyWith({
    String? query,
    NotificationCategory? category,
    bool? unreadOnly,
    bool clearCategory = false,
  }) {
    return NotificationFilterState(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      unreadOnly: unreadOnly ?? this.unreadOnly,
    );
  }
}

class NotificationFilterNotifier extends Notifier<NotificationFilterState> {
  @override
  NotificationFilterState build() => const NotificationFilterState();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(NotificationCategory? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
      return;
    }
    state = state.copyWith(category: category);
  }

  void setUnreadOnly(bool unreadOnly) {
    state = state.copyWith(unreadOnly: unreadOnly);
  }

  void reset() {
    state = const NotificationFilterState();
  }
}

final notificationFilterProvider =
    NotifierProvider<NotificationFilterNotifier, NotificationFilterState>(
  NotificationFilterNotifier.new,
);

final filteredNotificationsProvider =
    Provider<AsyncValue<List<AppNotification>>>((ref) {
  final asyncNotifications = ref.watch(watchNotificationsProvider);
  final filter = ref.watch(notificationFilterProvider);

  return asyncNotifications.whenData((notifications) {
    final filtered = notifications.where((notification) {
      if (notification.deleted || notification.archived) {
        return false;
      }

      if (filter.category != null && notification.category != filter.category) {
        return false;
      }

      if (filter.unreadOnly && notification.isRead) {
        return false;
      }

      if (filter.query.isNotEmpty) {
        final query = filter.query.toLowerCase();
        final titleMatch = notification.title.toLowerCase().contains(query);
        final bodyMatch = notification.body.toLowerCase().contains(query);
        if (!titleMatch && !bodyMatch) {
          return false;
        }
      }

      return true;
    }).toList();

    filtered.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.timestamp.compareTo(a.timestamp);
    });

    return filtered;
  });
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final asyncNotifications = ref.watch(watchNotificationsProvider);
  return asyncNotifications.valueOrNull
          ?.where((item) => !item.isRead && !item.deleted && !item.archived)
          .length ??
      0;
});

final recentNotificationsProvider = Provider<List<AppNotification>>((ref) {
  final asyncNotifications = ref.watch(filteredNotificationsProvider);
  final notifications = asyncNotifications.valueOrNull ?? const <AppNotification>[];
  return notifications.take(3).toList();
});
