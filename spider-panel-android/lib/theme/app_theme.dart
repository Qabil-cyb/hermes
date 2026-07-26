import 'package:flutter/material.dart';
import 'package:spider_panel/theme/app_theme.dart';
enum NeonTheme { red, blue, green }

class AppTheme {
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const double glassBorderRadius = 26.0;
  
  // Neon Colors
  static const Map<NeonTheme, Map<String, Color>> neonColors = {
    NeonTheme.red: {
      'primary': Color(0xFFFF3B30),
      'glow': Color(0x80FF3B30),
      'card': Color(0x33FF3B30),
      'border': Color(0x66FF3B30),
    },
    NeonTheme.blue: {
      'primary': Color(0xFF007AFF),
      'glow': Color(0x80007AFF),
      'card': Color(0x33007AFF),
      'border': Color(0x66007AFF),
    },
    NeonTheme.green: {
      'primary': Color(0xFF34C759),
      'glow': Color(0x8034C759),
      'card': Color(0x3334C759),
      'border': Color(0x6634C759),
    },
  };
  
  static ThemeData lightTheme(NeonTheme neon) {
    final colors = neonColors[neon]!;
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: colors['primary']!,
        secondary: colors['glow']!,
        surface: Colors.white,
        surfaceVariant: colors['card']!,
        outline: colors['border']!,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          side: BorderSide(color: colors['border']!, width: 1),
        ),
        shadowColor: colors['glow']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      textTheme: base.textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: colors['glow'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(glassBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: colors['border']!.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: colors['primary']!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
  
  static ThemeData darkTheme(NeonTheme neon) {
    final colors = neonColors[neon]!;
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: colors['primary']!,
        secondary: colors['glow']!,
        surface: const Color(0xFF1A1A2E),
        surfaceVariant: colors['card']!,
        outline: colors['border']!,
        background: const Color(0xFF0F0F1A),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      cardTheme: CardThemeData(
        color: const Color(0x1AFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          side: BorderSide(color: colors['border']!, width: 1),
        ),
        shadowColor: colors['glow']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: colors['glow'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(glassBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: colors['border']!.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(glassBorderRadius),
          borderSide: BorderSide(color: colors['primary']!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: Colors.white54),
        labelStyle: TextStyle(color: Colors.white70),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0x1AFFFFFF),
        selectedItemColor: colors['primary'],
        unselectedItemColor: Colors.white54,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  
  // Glassmorphism card decoration
  static BoxDecoration glassCard({
    required NeonTheme neon,
    bool isDark = true,
    double borderWidth = 1,
    double borderRadius = 1,
  }) {
    final colors = neonColors[neon]!;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(glassBorderRadius),
      border: Border.all(
        color: colors['border']!.withOpacity(0.3),
        width: borderWidth,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [colors['card']!.withOpacity(0.3), colors['card']!.withOpacity(0.1)]
            : [colors['card']!.withOpacity(0.4), colors['card']!.withOpacity(0.15)],
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
    );
  }
  
  // Neon glow button style
  static ButtonStyle neonButtonStyle(NeonTheme neon, {bool isDark = true}) {
    final colors = neonColors[neon]!;
    return ElevatedButton.styleFrom(
      backgroundColor: colors['primary'],
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: colors['glow'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(glassBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return colors['primary']!.withOpacity(0.8);
          }
          if (states.contains(WidgetState.hovered)) {
            return colors['glow'];
          }
          return null;
        },
      ),
    );
  }
}
