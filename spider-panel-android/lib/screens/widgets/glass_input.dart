import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';

class GlassInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;

  const GlassInput({
    super.key,
    this.controller,
    this.validator,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  State<GlassInput> createState() => _GlassInputState();
}

class _GlassInputState extends State<GlassInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border(
          top: BorderSide(
            color: _isFocused
                ? AppTheme.neonColors[NeonTheme.blue]['primary']!
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          left: BorderSide(
            color: _isFocused
                ? AppTheme.neonColors[NeonTheme.blue]['primary']!
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          right: BorderSide(
            color: _isFocused
                ? AppTheme.neonColors[NeonTheme.blue]['primary']!
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          bottom: BorderSide(
            color: _isFocused
                ? AppTheme.neonColors[NeonTheme.blue]['primary']!
                : Colors.white.withOpacity(0.05),
            width: 0.5,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isFocused
              ? [
                  AppTheme.neonColors[NeonTheme.blue]['card']!.withOpacity(0.4),
                  AppTheme.neonColors[NeonTheme.blue]['card']!.withOpacity(0.15),
                ]
              : [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppTheme.neonColors[NeonTheme.blue]['glow']!.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        onChanged: (_) => setState(() => _isFocused = true),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(widget.prefixIcon, color: Colors.white70, size: 22),
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16, left: 8),
                  child: InkWell(
                    onTap: widget.onSuffixPressed,
                    child: Icon(widget.suffixIcon, color: Colors.white70, size: 22),
                  ),
                )
              : null,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .slideY(begin: 0.2, end: 0);
  }
}