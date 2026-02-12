import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> push(Widget page, {Object? arguments}) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension NullStringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension DateTimeFormatExtension on DateTime {
  /// Formats the DateTime as 'yyyy-MM-dd HH:mm' or custom pattern if needed
  String format([String pattern = 'yyyy-MM-dd HH:mm']) {
    // You can use intl package for more complex formatting
    // For now, a simple implementation:
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${year.toString().padLeft(4, '0')}-${twoDigits(month)}-${twoDigits(day)} '
        '${twoDigits(hour)}:${twoDigits(minute)}';
  }
}

extension DateTimeHumanizeExtension on DateTime {
  /// Returns a human-readable string like 'Today', '2d ago', '3h ago', etc.
  String toHumanized() {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes < 1) {
          return 'Just now';
        } else if (difference.inMinutes < 60) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      }
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}

extension ConvertFlag on String {
  String get toFlag {
    return (this).toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }
}
