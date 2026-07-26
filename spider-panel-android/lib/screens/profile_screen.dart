import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final customTheme = ref.watch(customThemeProvider);
    final neonColor = AppTheme.neonColors[customTheme]['primary']!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F0F1A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              neonColor.withOpacity(0.4),
                              neonColor.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: neonColor.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: neonColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: neonColor,
                        ),
                      ).animate()
                        .scale(duration: 800.ms, curve: Curves.elasticOut)
                        .then()
                        .shimmer(duration: 2000.ms),
                      
                      const SizedBox(height: 24),
                      
                      // Name
                      Text(
                        'Spider Panel User',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),
                      
                      const SizedBox(height: 8),
                      
                      // API Key
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key, size: 16, color: Colors.white60),
                          const SizedBox(width: 8),
                          Text(
                            'API Key',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            authState.token?.substring(0, 10) ?? 'Not set',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                          if (authState.token != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle, size: 16, color: Colors.green),
                          ],
                        ],
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 24),
                
                // Days Remaining Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 48,
                        color: neonColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Days Remaining',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        authState.daysRemaining?.toString() ?? '30',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'days',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 24),
                
                // Join Date Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: neonColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: neonColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(Icons.calendar_today, color: neonColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Date',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'July 26, 2026',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3, end: 0),
                
                const SizedBox(height: 24),
                
                // Account Info
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.person,
                        label: 'Username',
                        value: authState.token != null ? 'Panel User' : 'Not logged in',
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.security,
                        label: 'Status',
                        value: authState.isAuthenticated ? 'Active' : 'Inactive',
                        theme: theme,
                        valueColor: authState.isAuthenticated ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.palette,
                        label: 'Theme',
                        value: customTheme.toString().split('.').last.toUpperCase(),
                        theme: theme,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0),
                
                const SizedBox(height: 32),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: NeonButton(
                    label: 'Logout',
                    icon: Icons.logout,
                    color: Colors.red,
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: AppTheme.neonColors[NeonTheme.red]['border']!,
                              width: 1,
                            ),
                          ),
                          title: Text('Logout', style: TextStyle(color: Colors.white)),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: AppTheme.neonColors[NeonTheme.red]['primary'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true) {
                        await ref.read(authStateProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 24),
                
                // Made by Amir
                Text(
                  'Made By Amir',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white38,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white60),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}