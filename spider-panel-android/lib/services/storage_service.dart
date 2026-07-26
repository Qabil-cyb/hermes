import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spider_panel/models/user_model.dart';
import 'package:spider_panel/models/inbound_model.dart';
import 'package:spider_panel/models/dashboard_model.dart';
import 'package:spider_panel/models/api_key_model.dart';
import 'package:spider_panel/models/news_model.dart';
import 'package:spider_panel/models/proxy_model.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  // Secure Storage
  Future<void> saveToken(String token) async => await _secureStorage.write(key: 'token', value: token);
  Future<String?> getToken() async => await _secureStorage.read(key: 'token');
  Future<void> clearToken() async => await _secureStorage.delete(key: 'token');
  
  Future<void> saveApiKey(String apiKey) async => await _secureStorage.write(key: 'api_key', value: apiKey);
  Future<String?> getApiKey() async => await _secureStorage.read(key: 'api_key');
  Future<void> clearApiKey() async => await _secureStorage.delete(key: 'api_key');
  
  Future<void> saveBaseUrl(String url) async => await _secureStorage.write(key: 'base_url', value: url);
  Future<String?> getBaseUrl() async => await _secureStorage.read(key: 'base_url');
  
  Future<void> saveDeviceId(String id) async => await _secureStorage.write(key: 'device_id', value: id);
  Future<String?> getDeviceId() async => await _secureStorage.read(key: 'device_id');
  
  Future<void> saveTheme(String theme) async => await _secureStorage.write(key: 'theme', value: theme);
  Future<String?> getTheme() async => await _secureStorage.read(key: 'theme');
  
  // Hive Boxes
  Box<User> get userBox => Hive.box<User>('users');
  Box<Inbound> get inboundBox => Hive.box<Inbound>('inbounds');
  Box<Client> get clientBox => Hive.box<Client>('clients');
  Box<DashboardStats> get dashboardBox => Hive.box<DashboardStats>('dashboard_stats');
  Box<ApiKey> get apiKeyBox => Hive.box<ApiKey>('api_keys');
  Box<NewsItem> get newsBox => Hive.box<NewsItem>('news_items');
  Box<ProxyConfig> get proxyBox => Hive.box<ProxyConfig>('proxy_configs');
  
  // Cache methods
  Future<void> cacheDashboard(DashboardStats stats) async {
    await dashboardBox.clear();
    await dashboardBox.add(stats);
  }
  
  DashboardStats? getCachedDashboard() {
    if (dashboardBox.isEmpty) return null;
    return dashboardBox.values.first;
  }
  
  Future<void> cacheInbounds(List<Inbound> inbounds) async {
    await inboundBox.clear();
    for (var inbound in inbounds) {
      await inboundBox.add(inbound);
    }
  }
  
  List<Inbound> getCachedInbounds() => inboundBox.values.toList();
  
  Future<void> cacheNews(List<NewsItem> news) async {
    await newsBox.clear();
    for (var item in news) {
      await newsBox.add(item);
    }
  }
  
  List<NewsItem> getCachedNews() => newsBox.values.toList();
  
  Future<void> cacheProxies(List<ProxyConfig> proxies) async {
    await proxyBox.clear();
    for (var proxy in proxies) {
      await proxyBox.add(proxy);
    }
  }
  
  List<ProxyConfig> getCachedProxies() => proxyBox.values.toList();
  
  Future<void> cacheApiKeys(List<ApiKey> keys) async {
    await apiKeyBox.clear();
    for (var key in keys) {
      await apiKeyBox.add(key);
    }
  }
  
  List<ApiKey> getCachedApiKeys() => apiKeyBox.values.toList();
  
  Future<void> clearAll() async {
    await userBox.clear();
    await inboundBox.clear();
    await clientBox.clear();
    await dashboardBox.clear();
    await apiKeyBox.clear();
    await newsBox.clear();
    await proxyBox.clear();
    await clearToken();
    await clearApiKey();
  }
}
