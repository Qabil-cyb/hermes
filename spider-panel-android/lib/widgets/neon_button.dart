import 'package:flutter/material.dart';
import 'package:spider_panel/theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NeonTheme? neon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.neon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    final colors = AppTheme.neonColors[effectiveNeon]!;
    
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colors['primary']!),
                  ),
                )
              : (icon != null ? Icon(icon) : const SizedBox.shrink()),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors['primary'],
            side: BorderSide(color: colors['primary']!, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.glassBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      );
    }
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(label),
        style: AppTheme.neonButtonStyle(effectiveNeon),
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

class NeonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final NeonTheme? neon;
  final double size;
  final Color? color;

  const NeonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.neon,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    final colors = AppTheme.neonColors[effectiveNeon]!;
    final buttonColor = color ?? colors['primary']!;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                buttonColor.withOpacity(0.3),
                buttonColor.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: buttonColor.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: buttonColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Icon(icon, color: buttonColor, size: size * 0.5),
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
