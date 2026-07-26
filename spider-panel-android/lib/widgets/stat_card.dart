import 'package:flutter/material.dart';
import 'package:spider_panel/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final double? progress;
  final String? subtitle;
  final VoidCallback? onTap;
  final NeonTheme? neon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.progress,
    this.subtitle,
    this.onTap,
    this.neon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    final colors = AppTheme.neonColors[effectiveNeon]!;
    
    return GlassCard(
      neon: effectiveNeon,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? colors['primary']!).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colors['primary'],
                  size: 24,
                ),
              ),
              const Spacer(),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                backgroundColor: colors['primary']!.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colors['primary']!),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  NeonTheme _getCurrentNeon(ThemeData theme) {
    if (theme.colorScheme.primary.value == AppTheme.neonColors[NeonTheme.red]!['primary']!.value) {
      return NeonTheme.red;
    } else if (theme.colorScheme.primary.value == AppTheme.neonColors[NeonTheme.green]!['primary']!.value) {
      return NeonTheme.green;
    }
    return NeonTheme.blue;
  }
}
