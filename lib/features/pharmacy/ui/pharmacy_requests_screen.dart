import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/request_model.dart';
import '../logic/pharmacy_cubit.dart';
import '../logic/pharmacy_state.dart';
import 'request_details_screen.dart';

class PharmacyRequestsScreen extends StatefulWidget {
  const PharmacyRequestsScreen({super.key});

  @override
  State<PharmacyRequestsScreen> createState() => _PharmacyRequestsScreenState();
}

class _PharmacyRequestsScreenState extends State<PharmacyRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, delivery, pickup
  String _sortBy = 'time'; // time, distance

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<PharmacyCubit>().loadPharmacyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('requests'.tr()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: 'filter'.tr(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SizedBox(
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color(0xFF34C759),
                borderRadius: BorderRadius.circular(8),
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('new'.tr()),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('accepted'.tr()),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('history'.tr()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<PharmacyCubit, PharmacyState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Initializing...')),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PharmacyCubit>().loadPharmacyData();
                    },
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
            loaded: (stats, newRequests, pendingRequests, completedRequests) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _RequestsList(
                    requests: newRequests,
                    type: 'new',
                    filter: _selectedFilter,
                    sortBy: _sortBy,
                  ),
                  _RequestsList(
                    requests: pendingRequests,
                    type: 'accepted',
                    filter: _selectedFilter,
                    sortBy: _sortBy,
                  ),
                  _RequestsList(
                    requests: completedRequests,
                    type: 'history',
                    filter: _selectedFilter,
                    sortBy: _sortBy,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'filter_sort'.tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedFilter = 'all';
                            _sortBy = 'time';
                          });
                          setState(() {});
                        },
                        child: Text('reset'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Delivery Type Filter
                  Text(
                    'delivery_type'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'all'.tr(),
                        selected: _selectedFilter == 'all',
                        onTap: () {
                          setModalState(() => _selectedFilter = 'all');
                          setState(() {});
                        },
                      ),
                      _FilterChip(
                        label: 'delivery'.tr(),
                        selected: _selectedFilter == 'delivery',
                        onTap: () {
                          setModalState(() => _selectedFilter = 'delivery');
                          setState(() {});
                        },
                      ),
                      _FilterChip(
                        label: 'pickup'.tr(),
                        selected: _selectedFilter == 'pickup',
                        onTap: () {
                          setModalState(() => _selectedFilter = 'pickup');
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sort By
                  Text(
                    'sort_by'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'newest_first'.tr(),
                        selected: _sortBy == 'time',
                        onTap: () {
                          setModalState(() => _sortBy = 'time');
                          setState(() {});
                        },
                      ),
                      _FilterChip(
                        label: 'nearest_first'.tr(),
                        selected: _sortBy == 'distance',
                        onTap: () {
                          setModalState(() => _sortBy = 'distance');
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34C759),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'apply'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF34C759) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final List<MedicineRequest> requests;
  final String type;
  final String filter;
  final String sortBy;

  const _RequestsList({
    required this.requests,
    required this.type,
    required this.filter,
    required this.sortBy,
  });

  List<MedicineRequest> _getFilteredAndSortedRequests() {
    // Create a mutable copy of the list
    var filtered = List<MedicineRequest>.from(requests);

    // Apply delivery type filter
    if (filter != 'all') {
      filtered = filtered.where((r) => r.deliveryType == filter).toList();
    }

    // Apply sorting
    if (sortBy == 'distance') {
      filtered.sort((a, b) {
        final distanceA = a.distance ?? double.infinity;
        final distanceB = b.distance ?? double.infinity;
        return distanceA.compareTo(distanceB);
      });
    } else {
      // Sort by time (newest first)
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredRequests = _getFilteredAndSortedRequests();

    if (filteredRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'no_requests'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PharmacyCubit>().loadPharmacyData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredRequests.length,
        itemBuilder: (context, index) {
          final request = filteredRequests[index];
          return _RequestCard(request: request);
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final MedicineRequest request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final timeAgo = _getTimeAgo(request.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: InkWell(
        // make background transparent
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PharmacyCubit>(),
                child: RequestDetailsScreen(request: request),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: request.medicineImage != null &&
                        request.medicineImage!.isNotEmpty
                    ? Image.asset(
                        request.medicineImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              const SizedBox(width: 12),
              // Request Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            request.medicineName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (request.medicineGenericName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        request.medicineGenericName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                    if (request.medicineForm != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        request.medicineForm!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Distance
                        if (request.distance != null) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${request.distance} km',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        // Quantity
                        Icon(
                          Icons.local_pharmacy_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${'qty'.tr()}: ${request.quantity}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Delivery Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: request.deliveryType == 'delivery'
                                ? Colors.blue.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            request.deliveryType == 'delivery'
                                ? 'delivery'.tr()
                                : 'pickup'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: request.deliveryType == 'delivery'
                                  ? Colors.blue.shade700
                                  : Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.medical_services_outlined,
        color: Colors.grey[400],
        size: 30,
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ${'ago'.tr()}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${'ago'.tr()}';
    } else {
      return '${difference.inDays}d ${'ago'.tr()}';
    }
  }
}
