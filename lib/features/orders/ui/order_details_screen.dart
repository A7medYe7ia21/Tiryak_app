import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../data/model/order.model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions_rounded;
        break;
      case OrderStatus.active:
        statusColor = Colors.blue;
        statusIcon = Icons.local_shipping_rounded;
        break;
      case OrderStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          "order_details".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      size: 48,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    order.status.name.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.id,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM dd, yyyy • hh:mm a').format(order.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Timeline
            if (order.status == OrderStatus.active ||
                order.status == OrderStatus.completed)
              _buildSection(
                context: context,
                title: "order_timeline".tr(),
                child: _buildTimeline(context, order.status),
              ),

            const SizedBox(height: 16),

            // Order Items
            _buildSection(
              context: context,
              title: "${"items".tr()} (${order.items.length})",
              child: Column(
                children: order.items
                    .map((item) => _buildOrderItem(context, item))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Order Information
            _buildSection(
              context: context,
              title: "order_information".tr(),
              child: Column(
                children: [
                  _buildInfoRow(
                    context: context,
                    icon: Icons.payment_rounded,
                    label: "payment_method".tr(),
                    value: "cash_on_delivery".tr(),
                  ),
                  if (order.estimatedDelivery != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context: context,
                      icon: Icons.local_shipping_outlined,
                      label: "estimated_delivery".tr(),
                      value: order.estimatedDelivery!,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context: context,
                    icon: Icons.location_on_outlined,
                    label: "delivery_address".tr(),
                    value: "123 Main Street, Cairo, Egypt",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Price Breakdown
            _buildSection(
              context: context,
              title: "order_summary".tr(),
              child: Column(
                children: [
                  _buildPriceRow(
                    context: context,
                    label: "subtotal".tr(),
                    value: "\$${order.total.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    context: context,
                    label: "delivery_fee".tr(),
                    value: "free".tr(),
                    valueColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    context: context,
                    label: "tax".tr(),
                    value: "\$0.00",
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF3D3D3D),
                                const Color(0xFF2D2D2D),
                              ]
                            : [
                                const Color(0xFF4A90E2).withOpacity(0.1),
                                const Color(0xFF357ABD).withOpacity(0.05),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          "\$${order.total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (order.status == OrderStatus.active) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Track order action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.location_on_rounded),
                        label: Text(
                          "track_order".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (order.status == OrderStatus.completed) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Reorder action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(
                          "reorder".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Contact support
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.support_agent_rounded,
                        color: isDark
                            ? const Color(0xFF4A90E2)
                            : const Color(0xFF357ABD),
                      ),
                      label: Text(
                        "contact_support".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                        ),
                      ),
                    ),
                  ),
                  if (order.status == OrderStatus.pending) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showCancelDialog(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.red.shade600,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red.shade600,
                        ),
                        label: Text(
                          "cancel_order".tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF4A90E2) : const Color(0xFF357ABD),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Text(
            "x${item.quantity}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "\$${item.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, OrderStatus status) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final steps = [
      {
        'title': 'order_received'.tr(),
        'icon': Icons.receipt_long_rounded,
        'completed': true,
      },
      {
        'title': 'order_confirmed'.tr(),
        'icon': Icons.check_circle_rounded,
        'completed': true,
      },
      {
        'title': 'processing'.tr(),
        'icon': Icons.inventory_2_rounded,
        'completed':
            status == OrderStatus.active || status == OrderStatus.completed,
      },
      {
        'title': 'out_for_delivery'.tr(),
        'icon': Icons.local_shipping_rounded,
        'completed':
            status == OrderStatus.active || status == OrderStatus.completed,
      },
      {
        'title': 'delivered'.tr(),
        'icon': Icons.home_rounded,
        'completed': status == OrderStatus.completed,
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;
        final isCompleted = step['completed'] as bool;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isDark
                            ? const Color(0xFF4A90E2)
                            : const Color(0xFF357ABD))
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step['icon'] as IconData,
                    size: 20,
                    color: isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? (isDark
                            ? const Color(0xFF4A90E2)
                            : const Color(0xFF357ABD))
                        : Colors.grey.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  step['title'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isCompleted ? FontWeight.w600 : FontWeight.normal,
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "cancel_order".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        content: Text(
          "cancel_order_confirmation".tr(),
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "cancel".tr(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "cancel_order".tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldCancel == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("order_cancelled_successfully".tr()),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
