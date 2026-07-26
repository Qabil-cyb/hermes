import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/services/storage_service.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';
import 'package:spider_panel/screens/widgets/glass_input.dart';
import 'package:spider_panel/screens/widgets/neon_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);
    final theme = Theme.of(context);
    final neon = Theme.of(context).brightness == Brightness.dark 
        ? NeonTheme.blue 
        : NeonTheme.red;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: GlassCard(
            neon: neon,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo and Title
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonColors[neon]!['primary']!.withOpacity(0.3),
                        AppTheme.neonColors[neon]!['glow']!.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.spa,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Spider Panel Login',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                
                // API Key Input
                GlassInput(
                  label: 'API KEY',
                  hint: 'Enter your API key here...',
                  controller: TextEditingController(), // TODO: Connect to provider
                  prefixIcon: Icons.key,
                  neon: neon,
                ),
                const SizedBox(height: 16),
                
                // Device ID (optional)
                GlassInput(
                  label: 'Device ID (Optional)',
                  hint: 'Leave empty to auto-generate...',
                  controller: TextEditingController(), // TODO: Connect to provider
                  prefixIcon: Icons.computer,
                  neon: neon,
                ),
                const SizedBox(height: 16),
                
                // Password (optional)
                GlassPasswordInput(
                  label: 'Password (Optional)',
                  hint: 'Enter password if required...',
                  neon: neon,
                ),
                const SizedBox(height: 32),
                
                // Error Message
                if (authState.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Login Button
                NeonButton(
                  label: 'ENTER',
                  icon: Icons.login,
                  neon: neon,
                  isLoading: authState.isLoading,
                  width: double.infinity,
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final storage = ref.read(storageServiceProvider);
                          final baseUrl = await storage.getBaseUrl() ?? '';
                          final apiKey = await storage.getApiKey() ?? '';
                          authNotifier.login(
                            baseUrl,
                            apiKey,
                            'device-id', // TODO: Get real device ID
                          );
                        },
                ),
                const SizedBox(height: 24),
                
                // Register Button
                NeonButton(
                  label: 'Register',
                  icon: Icons.person_add,
                  neon: neon,
                  isOutlined: true,
                  width: double.infinity,
                  onPressed: () {
                    // TODO: Navigate to register screen
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 300.ms),
        ),
      ),
    );
  }
}
