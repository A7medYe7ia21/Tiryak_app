import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../data/models/pharmacy_stats.dart';

class StatisticsScreen extends StatelessWidget {
  final PharmacyStats stats;

  const StatisticsScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('statistics'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'performance_metrics'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _StatCard(
              title: 'total_requests'.tr(),
              value: '${stats.totalRequests}',
              icon: Icons.assignment,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'new_requests'.tr(),
              value: '${stats.newRequests}',
              icon: Icons.inbox,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'pending_requests'.tr(),
              value: '${stats.pendingRequests}',
              icon: Icons.access_time,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'completed_today'.tr(),
              value: '${stats.completedToday}',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'response_rate'.tr(),
              value: '${stats.responseRate.toStringAsFixed(0)}%',
              icon: Icons.trending_up,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
