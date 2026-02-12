import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../data/model/order.model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample orders data - replace with actual data from your backend
  final List<Order> _sampleOrders = [
    Order(
      id: '#ORD-2024-001',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      items: [
        OrderItem(name: 'Panadol', quantity: 1, price: 79.99),
        OrderItem(name: 'Antinal', quantity: 2, price: 15.99),
      ],
      total: 111.97,
      status: OrderStatus.pending,
      estimatedDelivery: '2-3 days',
    ),
    Order(
      id: '#ORD-2024-002',
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: [
        OrderItem(name: 'High biotic', quantity: 1, price: 199.99),
      ],
      total: 199.99,
      status: OrderStatus.active,
      estimatedDelivery: '1-2 days',
    ),
    Order(
      id: '#ORD-2024-003',
      date: DateTime.now().subtract(const Duration(days: 5)),
      items: [
        OrderItem(name: 'Cold Free', quantity: 1, price: 45.99),
        OrderItem(name: 'Vitamin C', quantity: 1, price: 29.99),
      ],
      total: 75.98,
      status: OrderStatus.completed,
    ),
    Order(
      id: '#ORD-2024-004',
      date: DateTime.now().subtract(const Duration(days: 7)),
      items: [
        OrderItem(name: 'Aspirin', quantity: 3, price: 12.99),
      ],
      total: 38.97,
      status: OrderStatus.cancelled,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> _getOrdersByStatus(OrderStatus status) {
    return _sampleOrders.where((order) => order.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          "my_orders".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor:
                  isDark ? const Color(0xFF4A90E2) : const Color(0xFF357ABD),
              indicatorWeight: 3,
              labelColor:
                  isDark ? const Color(0xFF4A90E2) : const Color(0xFF357ABD),
              unselectedLabelColor: theme.colorScheme.primary.withOpacity(0.5),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: "pending".tr()),
                Tab(text: "active".tr()),
                Tab(text: "completed".tr()),
                Tab(text: "cancelled".tr()),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(OrderStatus.pending),
          _buildOrdersList(OrderStatus.active),
          _buildOrdersList(OrderStatus.completed),
          _buildOrdersList(OrderStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildOrdersList(OrderStatus status) {
    final orders = _getOrdersByStatus(status);
    final theme = Theme.of(context);

    if (orders.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index], theme);
      },
    );
  }

  Widget _buildEmptyState(OrderStatus status) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String emptyMessage;
    IconData emptyIcon;

    switch (status) {
      case OrderStatus.pending:
        emptyMessage = "no_pending_orders".tr();
        emptyIcon = Icons.pending_actions_rounded;
        break;
      case OrderStatus.active:
        emptyMessage = "no_active_orders".tr();
        emptyIcon = Icons.local_shipping_rounded;
        break;
      case OrderStatus.completed:
        emptyMessage = "no_completed_orders".tr();
        emptyIcon = Icons.check_circle_outline_rounded;
        break;
      case OrderStatus.cancelled:
        emptyMessage = "no_cancelled_orders".tr();
        emptyIcon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2D2D2D)
                  : const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              emptyIcon,
              size: 80,
              color: isDark
                  ? const Color(0xFF4A90E2).withOpacity(0.5)
                  : const Color(0xFF357ABD).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "start_shopping".tr(),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, ThemeData theme) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          // Header with Order ID and Status
          Container(
            padding: const EdgeInsets.all(20),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "order_id".tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.id,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a')
                                .format(order.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.status.name.tr(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 18,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${"items".tr()} (${order.items.length})",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Text(
                          "x${item.quantity}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "\$${item.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              const Color(0xFF4A90E2).withOpacity(0.08),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        "\$${order.total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.estimatedDelivery != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 16,
                        color: theme.colorScheme.primary.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${"estimated_delivery".tr()}: ",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        order.estimatedDelivery!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to order details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                          Icons.visibility_rounded,
                          size: 18,
                          color: isDark
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFF357ABD),
                        ),
                        label: Text(
                          "view_details".tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                          ),
                        ),
                      ),
                    ),
                    if (order.status == OrderStatus.active) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Track order action
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.location_on_rounded, size: 18),
                          label: Text(
                            "track_order".tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (order.status == OrderStatus.completed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Reorder action
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: Text(
                            "reorder".tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
