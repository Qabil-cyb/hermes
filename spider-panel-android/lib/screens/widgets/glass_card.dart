import 'package:flutter/material.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/providers/theme_provider.dart';

class GlassCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool isDark;
  final NeonTheme? neon;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = AppTheme.glassBorderRadius,
    this.isDark = true,
    this.neon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = ref.watch(customThemeProvider);
    final colors = AppTheme.neonColors[customTheme]!;
    final effectiveBorderColor = borderColor ?? colors['border']!.withOpacity(0.3);

    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  colors['card']!.withOpacity(0.3),
                  colors['card']!.withOpacity(0.1),
                ]
              : [
                  colors['card']!.withOpacity(0.4),
                  colors['card']!.withOpacity(0.15),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors['glow']!.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}