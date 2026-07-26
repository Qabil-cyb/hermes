import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/services/storage_service.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
final customThemeProvider = StateProvider<NeonTheme>((ref) => NeonTheme.blue);

final themeInitializerProvider = Provider((ref) {
  final storage = StorageService();
  storage.getTheme().then((theme) {
    if (theme != null) {
      switch (theme) {
        case 'red_neon': ref.read(customThemeProvider.notifier).state = NeonTheme.red; break;
        case 'blue_neon': ref.read(customThemeProvider.notifier).state = NeonTheme.blue; break;
        case 'green_neon': ref.read(customThemeProvider.notifier).state = NeonTheme.green; break;
      }
    }
  });
});
