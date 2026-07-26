import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';

class NeonButton extends ConsumerStatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isLoading;
  final bool isExpanded;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeonButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.isLoading = false,
    this.isExpanded = false,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  ConsumerState<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends ConsumerState<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ref.watch(customThemeProvider);
    final colors = AppTheme.neonColors[customTheme]!;
    final effectiveColor = widget.color ?? colors['primary']!;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Widget buttonChild = Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.identity().scaled(_isPressed ? 0.98 : 1.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isEnabled ? widget.onPressed : null,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  width: widget.isExpanded ? double.infinity : null,
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        effectiveColor.withOpacity(isEnabled ? 0.8 : 0.3),
                        effectiveColor.withOpacity(isEnabled ? 0.6 : 0.2),
                      ],
                    ),
                    border: Border.all(
                      color: effectiveColor.withOpacity(isEnabled ? 0.5 : 0.2),
                      width: 1.5,
                    ),
                    boxShadow: isEnabled
                        ? [
                            BoxShadow(
                              color: effectiveColor.withOpacity(_glowAnimation.value * 0.5),
                              blurRadius: 20 * _glowAnimation.value,
                              spreadRadius: 2 * _glowAnimation.value,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: buttonChild,
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }
}

class NeonIconButton extends ConsumerStatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final Tooltip? tooltip;

  const NeonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 48,
    this.tooltip,
  });

  @override
  ConsumerState<NeonIconButton> createState() => _NeonIconButtonState();
}

class _NeonIconButtonState extends ConsumerState<NeonIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ref.watch(customThemeProvider);
    final colors = AppTheme.neonColors[customTheme]!;
    final effectiveColor = widget.color ?? colors['primary']!;
    final isEnabled = widget.onPressed != null;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    effectiveColor.withOpacity(isEnabled ? 0.3 : 0.1),
                    effectiveColor.withOpacity(isEnabled ? 0.1 : 0.05),
                  ],
                ),
                border: Border.all(
                  color: effectiveColor.withOpacity(isEnabled ? 0.5 : 0.2),
                  width: 2,
                ),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: effectiveColor.withOpacity(_glowAnimation.value * 0.5),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                color: effectiveColor.withOpacity(isEnabled ? 1.0 : 0.4),
                size: widget.size * 0.4,
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class NeonFAB extends ConsumerStatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;

  const NeonFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.tooltip,
  });

  @override
  ConsumerState<NeonFAB> createState() => _NeonFABState();
}

class _NeonFABState extends ConsumerState<NeonFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ref.watch(customThemeProvider);
    final colors = AppTheme.neonColors[customTheme]!;
    final effectiveColor = widget.color ?? colors['primary']!;
    final isEnabled = widget.onPressed != null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              onTap: isEnabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      effectiveColor.withOpacity(isEnabled ? 0.8 : 0.3),
                      effectiveColor.withOpacity(isEnabled ? 0.6 : 0.2),
                    ],
                  ),
                  border: Border.all(
                    color: effectiveColor.withOpacity(isEnabled ? 0.5 : 0.2),
                    width: 2,
                  ),
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: effectiveColor.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.5, 0.5));
  }
}