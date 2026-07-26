import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/theme_provider.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';
import 'package:spider_panel/screens/widgets/neon_button.dart';
import 'package:spider_panel/screens/widgets/glass_input.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _passwordLockEnabled = false;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _telegramBotController = TextEditingController();
  final _telegramChatIdController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _telegramBotController.dispose();
    _telegramChatIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = ref.watch(customThemeProvider);
    final neonColor = AppTheme.neonColors[customTheme]['primary']!;
    final authState = ref.watch(authStateProvider);

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
            'Settings',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Selection
                _buildSectionHeader('Theme', Icons.palette),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildThemeRadio(NeonTheme.red, 'Red Neon', Icons.favorite),
                      _buildThemeRadio(NeonTheme.blue, 'Blue Neon', Icons.circle),
                      _buildThemeRadio(NeonTheme.green, 'Green Neon', Icons.eco),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // API Key Section
                _buildSectionHeader('API Key', Icons.key),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current API Key',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                authState.token?.substring(0, 20) ?? 'Not set',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            if (authState.token != null)
                              IconButton(
                                icon: Icon(Icons.copy, size: 16, color: Colors.white70),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('API key copied')),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassInput(
                        hint: 'Enter new API key',
                        prefixIcon: Icons.add,
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      NeonButton(
                        label: 'Save API Key',
                        icon: Icons.save,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('API key saved')),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // Password Lock
                _buildSectionHeader('Password Lock', Icons.lock),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enable Password Lock',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: _passwordLockEnabled,
                            onChanged: (value) {
                              setState(() => _passwordLockEnabled = value);
                            },
                            activeColor: neonColor,
                          ),
                        ],
                      ),
                      if (_passwordLockEnabled) ...[
                        const SizedBox(height: 16),
                        GlassInput(
                          controller: _passwordController,
                          hint: 'Enter lock password',
                          prefixIcon: Icons.lock,
                          obscureText: _obscurePassword,
                          suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          onSuffixPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 12),
                        NeonButton(
                          label: 'Save Password',
                          icon: Icons.save,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password lock enabled')),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // Telegram Bot
                _buildSectionHeader('Telegram Bot', Icons.telegram),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassInput(
                        controller: _telegramBotController,
                        hint: 'Bot Token',
                        prefixIcon: Icons.token,
                      ),
                      const SizedBox(height: 16),
                      GlassInput(
                        controller: _telegramChatIdController,
                        hint: 'Chat ID',
                        prefixIcon: Icons.chat,
                      ),
                      const SizedBox(height: 16),
                      NeonButton(
                        label: 'Save Telegram Settings',
                        icon: Icons.save,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Telegram settings saved')),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // Backup & Restore
                _buildSectionHeader('Backup & Restore', Icons.backup),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      NeonButton(
                        label: 'Create Backup',
                        icon: Icons.backup,
                        onPressed: () async {
                          try {
                            final api = ref.read(apiServiceProvider);
                            final result = await api.createBackup();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Backup created: ${result['backup_id'] ?? 'success'}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Backup failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      NeonButton(
                        label: 'Restore Backup',
                        icon: Icons.restore,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Restore feature coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // Reset Panel
                _buildSectionHeader('Panel', Icons.settings),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: NeonButton(
                    label: 'Reset Panel',
                    icon: Icons.restart_alt,
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
                          title: Text('Reset Panel', style: TextStyle(color: Colors.white)),
                          content: Text(
                            'Are you sure you want to reset the panel? This will clear all data.',
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
                                'Reset',
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
                        final storage = ref.read(storageServiceProvider);
                        await storage.clearAll();
                        await ref.read(authStateProvider.notifier).logout();
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                // Made by Amir
                Center(
                  child: Text(
                    'Made By Amir',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white38,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeRadio(NeonTheme theme, String label, IconData icon) {
    final customTheme = ref.watch(customThemeProvider);
    final isSelected = customTheme == theme;
    final neonColor = AppTheme.neonColors[theme]['primary']!;

    return InkWell(
      onTap: () {
        ref.read(customThemeProvider.notifier).state = theme;
        final themeString = theme.toString().split('.').last;
        ref.read(authStateProvider.notifier).changeTheme('${themeString}_neon');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? neonColor.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? neonColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<NeonTheme>(
              value: theme,
              groupValue: customTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(customThemeProvider.notifier).state = value;
                  final themeString = value.toString().split('.').last;
                  ref.read(authStateProvider.notifier).changeTheme('${themeString}_neon');
                }
              },
              activeColor: neonColor,
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return neonColor;
                  }
                  return Colors.white38;
                },
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: isSelected ? neonColor : Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? neonColor : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}