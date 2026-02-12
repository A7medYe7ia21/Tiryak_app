import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/go_router.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Logo
              Image.asset("assets/logo.png"),
              const Expanded(child: SizedBox(height: 20)),
              // Title
              Text(
                'get_started'.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'choose_how_to_use'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Patient Card
              _UserTypeCard(
                icon: Icons.person_outline,
                iconColor: const Color(0xFF4A90E2),
                backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
                title: 'im_a_patient'.tr(),
                subtitle: 'search_request_medicines'.tr(),
                onTap: () {
                  _navigateToPatientFlow(context);
                },
              ),

              const SizedBox(height: 20),

              // Pharmacy Card
              _UserTypeCard(
                icon: Icons.local_pharmacy_outlined,
                iconColor: const Color(0xFF34C759),
                backgroundColor: const Color(0xFF34C759).withOpacity(0.1),
                title: 'im_a_pharmacy'.tr(),
                subtitle: 'receive_respond_requests'.tr(),
                onTap: () {
                  _navigateToPharmacyFlow(context);
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPatientFlow(BuildContext context) {
    context.go('${AppPath.authGate}?type=patient');
  }

  void _navigateToPharmacyFlow(BuildContext context) {
    context.go('${AppPath.authGate}?type=pharmacy');
  }
}

class _UserTypeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 20),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
