import 'package:flutter/material.dart';
import 'package:backdropp_filter/backdropp_filter.dart';
import 'package:spider_panel/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final NeonTheme? neon;
  final bool isDark;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.neon,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.glassBorderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: AppTheme.glassCard(
              neon: effectiveNeon,
              isDark: isDark,
            ),
            child: child,
          ),
        ),
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

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final NeonTheme? neon;
  final bool isDark;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.neon,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(
        neon: effectiveNeon,
        isDark: isDark,
      ),
      child: child,
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
