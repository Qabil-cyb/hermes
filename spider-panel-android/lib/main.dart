import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/screens/splash_screen.dart';
import 'package:spider_panel/services/api_service.dart';
import 'package:spider_panel/services/storage_service.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/providers/theme_provider.dart';
import 'package:spider_panel/models/user_model.dart';
import 'package:spider_panel/models/inbound_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(InboundAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(DashboardStatsAdapter());
  Hive.registerAdapter(ApiKeyAdapter());
  Hive.registerAdapter(NewsItemAdapter());
  Hive.registerAdapter(ProxyConfigAdapter());
  
  // Open boxes
  await Hive.openBox<User>('users');
  await Hive.openBox<Inbound>('inbounds');
  await Hive.openBox<Client>('clients');
  await Hive.openBox<DashboardStats>('dashboard_stats');
  await Hive.openBox<ApiKey>('api_keys');
  await Hive.openBox<NewsItem>('news_items');
  await Hive.openBox<ProxyConfig>('proxy_configs');
  
  runApp(const ProviderScope(child: SpiderPanelApp()));
}

class SpiderPanelApp extends ConsumerWidget {
  const SpiderPanelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final customTheme = ref.watch(customThemeProvider);
    
    return MaterialApp(
      title: 'Spider Panel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(customTheme),
      darkTheme: AppTheme.darkTheme(customTheme),
      themeMode: themeMode,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/users': (context) => const UsersScreen(),
        '/inbounds': (context) => const InboundsScreen(),
        '/ai': (context) => const AIScreen(),
        '/news': (context) => const NewsScreen(),
        '/proxy': (context) => const ProxyScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
