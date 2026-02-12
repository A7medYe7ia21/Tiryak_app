import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../notifications/notification_cubit.dart';
import '../notifications/notification_state.dart';

class CustomSalomonBottomBar extends StatelessWidget {
  const CustomSalomonBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });
  final int selectedIndex;
  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SalomonBottomBar(
        key: ValueKey(currentLocale.toString()),
        currentIndex: selectedIndex,
        onTap: onTabChange,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("home_nav".tr()),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: _buildNotificationBadge(icon: Icons.notifications),
            title: Text("orders_nav".tr()),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("profile_nav".tr()),
            selectedColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge({required IconData icon}) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        int badgeCount = state.notificationBadgeCount;
        return Stack(
          children: [
            Icon(icon),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
