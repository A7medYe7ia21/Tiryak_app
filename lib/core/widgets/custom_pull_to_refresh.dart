import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      animSpeedFactor: 4.0,
      showChildOpacityTransition: false,
      color: Theme.of(context).colorScheme.secondary,
      height: MediaQuery.of(context).size.height * 0.15,
      backgroundColor: Theme.of(context).primaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
