import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool notificationsEnabled;
  final int notificationBadgeCount;
  final bool isNotificationScreenOpen;

  const NotificationState({
    required this.notificationsEnabled,
    this.notificationBadgeCount = 0,
    this.isNotificationScreenOpen = false,
  });

  NotificationState copyWith({
    bool? notificationsEnabled,
    int? notificationBadgeCount,
    bool? isNotificationScreenOpen,
  }) {
    return NotificationState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationBadgeCount:
          notificationBadgeCount ?? this.notificationBadgeCount,
      isNotificationScreenOpen:
          isNotificationScreenOpen ?? this.isNotificationScreenOpen,
    );
  }

  @override
  List<Object> get props => [
        notificationsEnabled,
        notificationBadgeCount,
        isNotificationScreenOpen,
      ];
}
