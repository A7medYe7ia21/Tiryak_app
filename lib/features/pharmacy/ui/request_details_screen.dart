import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/request_model.dart';
import '../logic/pharmacy_cubit.dart';

class RequestDetailsScreen extends StatelessWidget {
  final MedicineRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNew = request.status == 'new';
    final isPending = request.status == 'pending';

    return Scaffold(
      appBar: AppBar(
        title: Text('request_details'.tr()),
        actions: [
          if (request.status != 'completed')
            PopupMenuButton<String>(
              onSelected: (value) {
                _handleAction(context, value);
              },
              itemBuilder: (context) => [
                if (isNew)
                  PopupMenuItem(
                    value: 'accept',
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('accept_request'.tr()),
                      ],
                    ),
                  ),
                if (isPending)
                  PopupMenuItem(
                    value: 'complete',
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('mark_completed'.tr()),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'cancel',
                  child: Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('cancel_request'.tr()),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(request.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusLabel(request.status),
                style: TextStyle(
                  color: _getStatusColor(request.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Patient Info
            _SectionCard(
              icon: Icons.person,
              title: 'patient_information'.tr(),
              children: [
                _InfoRow(
                  label: 'patient_name'.tr(),
                  value: request.patientName,
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'request_date'.tr(),
                  value: DateFormat('MMM dd, yyyy - HH:mm')
                      .format(request.createdAt),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Medicine Info
            _SectionCard(
              icon: Icons.medical_services,
              title: 'medicine_information'.tr(),
              children: [
                if (request.medicineImage != null &&
                    request.medicineImage!.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        request.medicineImage!,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(Icons.medical_services, size: 48),
                        ),
                      ),
                    ),
                  ),
                if (request.medicineImage != null &&
                    request.medicineImage!.isNotEmpty)
                  const SizedBox(height: 16),
                _InfoRow(
                  label: 'medicine_name'.tr(),
                  value: request.medicineName,
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'quantity'.tr(),
                  value: '${request.quantity}',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Delivery Info
            _SectionCard(
              icon: request.deliveryType == 'delivery'
                  ? Icons.local_shipping
                  : Icons.store,
              title: 'delivery_information'.tr(),
              children: [
                _InfoRow(
                  label: 'delivery_type'.tr(),
                  value: request.deliveryType == 'delivery'
                      ? 'delivery'.tr()
                      : 'pickup'.tr(),
                ),
                if (request.deliveryType == 'delivery' &&
                    request.address != null) ...[
                  const Divider(height: 24),
                  _InfoRow(
                    label: 'delivery_address'.tr(),
                    value: request.address!,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Additional Info
            if (request.note != null || request.prescriptionUrl != null)
              _SectionCard(
                icon: Icons.info_outline,
                title: 'additional_information'.tr(),
                children: [
                  if (request.note != null) ...[
                    Text(
                      'note'.tr(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      request.note!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (request.note != null && request.prescriptionUrl != null)
                    const Divider(height: 24),
                  if (request.prescriptionUrl != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.attach_file, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'prescription_attached'.tr(),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // View prescription
                          },
                          child: Text('view'.tr()),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: request.status != 'completed'
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (isNew) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleAction(context, 'cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('reject'.tr()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _handleAction(context, 'accept'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('accept_request'.tr()),
                        ),
                      ),
                    ],
                    if (isPending)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleAction(context, 'complete'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('mark_completed'.tr()),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  void _handleAction(BuildContext context, String action) {
    String newStatus = request.status;
    String message = '';

    switch (action) {
      case 'accept':
        newStatus = 'pending';
        message = 'request_accepted'.tr();
        break;
      case 'complete':
        newStatus = 'completed';
        message = 'request_completed'.tr();
        break;
      case 'cancel':
        newStatus = 'cancelled';
        message = 'request_cancelled'.tr();
        break;
    }

    context.read<PharmacyCubit>().updateRequestStatus(request.id, newStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    Navigator.pop(context);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'new':
        return 'new'.tr().toUpperCase();
      case 'pending':
        return 'pending'.tr().toUpperCase();
      case 'completed':
        return 'completed'.tr().toUpperCase();
      case 'cancelled':
        return 'cancelled'.tr().toUpperCase();
      default:
        return status.toUpperCase();
    }
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
