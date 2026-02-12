import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PharmacyProfileScreen extends StatelessWidget {
  const PharmacyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pharmacy_profile'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF34C759),
                    Color(0xFF28A745),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Pharmacy Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Pharmacy Icon
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34C759)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.local_pharmacy,
                                    color: Color(0xFF34C759),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Pharmacy Name & Status
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'pharmacy_name'.tr(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF34C759),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'open_now'.tr(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit Button
                                IconButton(
                                  onPressed: () {
                                    // Edit pharmacy info
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Contact Info
                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              text: 'pharmacy_address'.tr(),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.phone_outlined,
                              text: 'pharmacy_phone'.tr(),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.email_outlined,
                              text: 'pharmacy_email'.tr(),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.access_time,
                              text: 'pharmacy_hours'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Performance Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'performance'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _PerformanceCard(
                          value: '156',
                          label: 'total_orders'.tr(),
                          color: Colors.blue.shade50,
                          valueColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PerformanceCard(
                          value: '4.8',
                          label: 'rating'.tr(),
                          color: Colors.green.shade50,
                          valueColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PerformanceCard(
                          value: '92%',
                          label: 'response_rate'.tr(),
                          color: Colors.purple.shade50,
                          valueColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Settings Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsItem(
                    icon: Icons.access_time,
                    title: 'working_hours'.tr(),
                    onTap: () {
                      // Navigate to working hours
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.location_on_outlined,
                    title: 'location_settings'.tr(),
                    onTap: () {
                      // Navigate to location settings
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'inventory_management'.tr(),
                    onTap: () {
                      // Navigate to inventory
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'account'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsItem(
                    icon: Icons.payment_outlined,
                    title: 'payment_information'.tr(),
                    onTap: () {
                      // Navigate to payment info
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.description_outlined,
                    title: 'legal_documents'.tr(),
                    onTap: () {
                      // Navigate to legal docs
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.article_outlined,
                    title: 'terms_conditions'.tr(),
                    onTap: () {
                      // Navigate to terms
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // App Version
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'app_version'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Pharmacy v1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Log Out Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'log_out'.tr(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('log_out'.tr()),
        content: Text('logout_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            child: Text(
              'log_out'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color valueColor;

  const _PerformanceCard({
    required this.value,
    required this.label,
    required this.color,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 22, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }
}
