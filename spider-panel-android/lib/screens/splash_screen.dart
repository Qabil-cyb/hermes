import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/services/storage_service.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = StorageService();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Spider Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.purple.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.spa,
                size: 60,
                color: Colors.white,
              ).animate(
                onBegin: (style) => style.copyWith(opacity: 0, scale: 0.5),
                onEnd: (style) => style.copyWith(opacity: 1, scale: 1),
              ).animateInterval(
                const Duration(milliseconds: 500),
                reverseDuration: const Duration(milliseconds: 300),
              ).fadeIn().scale(),
            ),
            const SizedBox(height: 32),
            // App Title
            Text(
              'SPIDER PANEL',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.blue.withOpacity(0.8),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ).animate(
              onBegin: (style) => style.copyWith(opacity: 0, y: -20),
              onEnd: (style) => style.copyWith(opacity: 1, y: 0),
            ).animateInterval(const Duration(milliseconds: 500)),
            const SizedBox(height: 48),
            // Loading indicator with neon glow
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
            ).animate(
              onBegin: (style) => style.copyWith(width: 0),
              onEnd: (style) => style.copyWith(width: 200),
            ).animateInterval(const Duration(milliseconds: 800)),
            const SizedBox(height: 80),
            // "Made By Amir" with animated opacity
            Text(
              'Made By Amir',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ).animate(
              onBegin: (style) => style.copyWith(opacity: 0),
              onEnd: (style) => style.copyWith(opacity: 1),
            ).animateInterval(const Duration(milliseconds: 1200)),
          ],
        ),
      ),
    );
  }
}
