import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double? percentage;
  final IconData icon;
  final Color iconColor;
  final String? subtitle;
  final NeonTheme? neon;
  final Animation<double>? animation;
  final double? progress;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.percentage,
    required this.icon,
    this.iconColor = Colors.white,
    this.subtitle,
    this.neon,
    this.animation,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = percentage ?? progress;
    final accent = iconColor;

    Widget card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accent, size: 32),
              if (pct != null)
                Text(
                  '${(pct! * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
          if (pct != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              borderRadius: BorderRadius.circular(4),
              minHeight: 4,
            ),
          ],
        ],
      ),
    );

    if (animation != null) {
      card = FadeTransition(
        opacity: animation!,
        child: card,
      );
    }

    return card;
  }
}
