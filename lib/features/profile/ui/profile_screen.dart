import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/router/go_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/logic/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF1F1F1F),
                            const Color(0xFF2D2D2D),
                          ]
                        : [
                            const Color(0xFF4A90E2),
                            const Color(0xFF357ABD),
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Profile Avatar with modern design
                      Hero(
                        tag: 'profile_avatar',
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: isDark
                                ? const Color(0xFF2D2D2D)
                                : const Color(0xFF4A90E2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      Text(
                        currentUser?.name ?? 'John Doe',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Email
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              currentUser?.email ?? 'john.doe@email.com',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Account Information Section
                _buildSection(
                  context: context,
                  title: "account_information".tr(),
                  children: [
                    _buildModernTile(
                      context: context,
                      icon: Icons.phone_rounded,
                      title: "phone_number".tr(),
                      subtitle: currentUser?.phoneNumber ?? '+20 123 456 7890',
                      onTap: () {},
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.email_rounded,
                      title: "email".tr(),
                      subtitle: currentUser?.email ?? 'john.doe@email.com',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Preferences Section
                _buildSection(
                  context: context,
                  title: "preferences".tr(),
                  children: [
                    _buildModernTile(
                      context: context,
                      icon: Icons.brightness_6_rounded,
                      title: "dark_mode".tr(),
                      subtitle: "enable_dark_mode".tr(),
                      trailing: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return Switch(
                            value: !themeProvider.isLightMode,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                            activeColor: isDark
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFF357ABD),
                          );
                        },
                      ),
                      onTap: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.language_rounded,
                      title: "language".tr(),
                      subtitle: context.locale.languageCode == 'ar'
                          ? 'العربية'
                          : 'English',
                      onTap: () {
                        // Toggle language
                        if (context.locale.languageCode == 'ar') {
                          context.setLocale(const Locale('en'));
                        } else {
                          context.setLocale(const Locale('ar'));
                        }
                      },
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.notifications_rounded,
                      title: "notifications".tr(),
                      subtitle: "enable_push_notifications".tr(),
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // More Options Section
                _buildSection(
                  context: context,
                  title: "support_about".tr(),
                  children: [
                    _buildModernTile(
                      context: context,
                      icon: Icons.location_on_rounded,
                      title: "saved_addresses".tr(),
                      onTap: () {},
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.credit_card_rounded,
                      title: "payment_methods".tr(),
                      onTap: () {},
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.help_outline_rounded,
                      title: "help_support".tr(),
                      subtitle: "get_help_support".tr(),
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Legal Section
                _buildSection(
                  context: context,
                  title: "about".tr(),
                  children: [
                    _buildModernTile(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: "app_version".tr(),
                      subtitle: '1.0.0',
                      showArrow: false,
                      onTap: () {},
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.description_rounded,
                      title: "terms_conditions".tr(),
                      onTap: () {},
                    ),
                    _buildModernTile(
                      context: context,
                      icon: Icons.privacy_tip_rounded,
                      title: "privacy_policy".tr(),
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Logout Button with modern design
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showLogoutDialog(context, authCubit),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.red.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "log_out".tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
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
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3D3D3D)
                      : const Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF357ABD),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing Widget or Arrow
              if (trailing != null)
                trailing
              else if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AuthCubit authCubit,
  ) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final shouldLogout = await showDialog<bool>(
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
                Icons.logout_rounded,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "log_out".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        content: Text(
          "logout_confirmation".tr(),
          style: TextStyle(
            fontSize: 16,
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
                fontSize: 16,
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
              "log_out".tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      // Clear authentication data
      await SharedPrefHelper.clearAllSecuredData();

      if (!context.mounted) return;

      // Update auth state
      authCubit.checkAuth();

      if (context.mounted) {
        // Navigate to splash screen
        context.go(AppPath.splash);
      }
    }
  }
}
