import 'package:dio/dio.dart';
import 'package:spider_panel/models/user_model.dart';
import 'package:spider_panel/models/inbound_model.dart';
import 'package:spider_panel/models/dashboard_model.dart';
import 'package:spider_panel/models/api_key_model.dart';
import 'package:spider_panel/models/news_model.dart';
import 'package:spider_panel/models/proxy_model.dart';

class ApiService {
  final Dio _dio = Dio();
  String? _token;
  String? _baseUrl;
  
  ApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(LogInterceptor(responseBody: false));
  }
  
  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }
  
  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer \$token';
  }
  
  void clearToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
  }
  
  // Auth
  Future<Map<String, dynamic>> login(String apiKey, String deviceId) async {
    final response = await _dio.post('/api/auth/login', data: {
      'api_key': apiKey,
      'device_id': deviceId,
    });
    return response.data;
  }
  
  Future<Map<String, dynamic>> refreshToken(String token) async {
    final response = await _dio.post('/api/auth/refresh', data: {'token': token});
    return response.data;
  }
  
  // Dashboard
  Future<DashboardStats> getDashboard() async {
    final response = await _dio.get('/api/dashboard');
    return DashboardStats.fromJson(response.data);
  }
  
  // Users
  Future<List<Client>> getUsers({int page = 1, int limit = 10, String? search, String? status}) async {
    final response = await _dio.get('/api/users', queryParameters: {
      'page': page, 'limit': limit, if (search != null) 'search': search, if (status != null) 'status': status,
    });
    final List data = response.data['users'] ?? [];
    return data.map((e) => Client.fromJson(e)).toList();
  }
  
  Future<Client> createUser({required String username, required String inboundId, int trafficLimit = 0, int expireDays = 30, int ipLimit = 1, String description = ''}) async {
    final response = await _dio.post('/api/users', data: {
      'username': username, 'inbound_id': inboundId,
      'traffic_limit': trafficLimit, 'expire_days': expireDays,
      'ip_limit': ipLimit, 'description': description,
    });
    return Client.fromJson(response.data);
  }
  
  Future<void> deleteUser(String id) async {
    await _dio.delete('/api/users/\$id');
  }
  
  Future<void> resetUserTraffic(String id) async {
    await _dio.post('/api/users/\$id/reset');
  }
  
  Future<void> enableUser(String id) async {
    await _dio.post('/api/users/\$id/enable');
  }
  
  Future<void> disableUser(String id) async {
    await _dio.post('/api/users/\$id/disable');
  }
  
  Future<String> getUserQr(String id) async {
    final response = await _dio.get('/api/users/\$id/qr');
    return response.data['qr_code'] ?? '';
  }
  
  Future<Map<String, dynamic>> getUserConfig(String id) async {
    final response = await _dio.get('/api/users/\$id/config');
    return response.data;
  }
  
  // Inbounds
  Future<List<Inbound>> getInbounds() async {
    final response = await _dio.get('/api/inbounds');
    final List data = response.data['inbounds'] ?? [];
    return data.map((e) => Inbound.fromJson(e)).toList();
  }
  
  Future<Inbound> createInbound(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/inbounds', data: data);
    return Inbound.fromJson(response.data);
  }
  
  Future<void> deleteInbound(String id) async {
    await _dio.delete('/api/inbounds/\$id');
  }
  
  Future<void> enableInbound(String id) async {
    await _dio.post('/api/inbounds/\$id/enable');
  }
  
  Future<void> disableInbound(String id) async {
    await _dio.post('/api/inbounds/\$id/disable');
  }
  
  Future<Map<String, dynamic>> getInboundJson(String id) async {
    final response = await _dio.get('/api/inbounds/\$id/json');
    return response.data;
  }
  
  // Hermes AI
  Future<Map<String, dynamic>> installHermes() async {
    final response = await _dio.post('/api/hermes/install');
    return response.data;
  }
  
  Future<Map<String, dynamic>> chatWithHermes(String message, String? conversationId) async {
    final response = await _dio.post('/api/hermes/chat', data: {
      'message': message, 'conversation_id': conversationId,
    });
    return response.data;
  }
  
  Future<String> uploadImage(String filePath) async {
    final response = await _dio.post('/api/hermes/upload', data: {
      'file': await MultipartFile.fromFile(filePath),
    });
    return response.data['url'] ?? '';
  }
  
  // News
  Future<List<NewsItem>> getNews({bool forceRefresh = false}) async {
    final response = await _dio.get('/api/news', queryParameters: {'force_refresh': forceRefresh});
    final List data = response.data['items'] ?? [];
    return data.map((e) => NewsItem.fromJson(e)).toList();
  }
  
  // Proxy
  Future<List<ProxyConfig>> getProxies() async {
    final response = await _dio.get('/api/proxy');
    final List data = response.data;
    return data.map((e) => ProxyConfig.fromJson(e)).toList();
  }
  
  Future<ProxyConfig> addProxy(String country, String ip, int port, String type) async {
    final response = await _dio.post('/api/proxy', data: {
      'country': country, 'ip': ip, 'port': port, 'type': type,
    });
    return ProxyConfig.fromJson(response.data);
  }
  
  Future<void> assignProxy(String userId, String proxyId) async {
    await _dio.post('/api/proxy/assign', data: {'user_id': userId, 'proxy_id': proxyId});
  }
  
  // Settings
  Future<void> changeTheme(String theme) async {
    await _dio.patch('/api/settings/theme', data: {'theme': theme});
  }
  
  Future<Map<String, dynamic>> getSettings() async {
    final response = await _dio.get('/api/settings');
    return response.data;
  }
  
  // Profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get('/api/profile');
    return response.data;
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.patch('/api/profile', data: data);
  }
  
  // API Keys
  Future<List<ApiKey>> getApiKeys() async {
    final response = await _dio.get('/api/apikeys');
    final List data = response.data['keys'] ?? [];
    return data.map((e) => ApiKey.fromJson(e)).toList();
  }
  
  Future<ApiKey> createApiKey(String? owner, String? description, int daysValid) async {
    final response = await _dio.post('/api/apikeys', data: {
      'owner': owner, 'description': description, 'days_valid': daysValid,
    });
    return ApiKey.fromJson(response.data);
  }
  
  Future<void> deleteApiKey(String id) async {
    await _dio.delete('/api/apikeys/\$id');
  }
  
  Future<ApiKey> regenerateApiKey(String id) async {
    final response = await _dio.post('/api/apikeys/\$id/regenerate');
    return ApiKey.fromJson(response.data);
  }
  
  // Backup
  Future<Map<String, dynamic>> createBackup() async {
    final response = await _dio.post('/api/backup');
    return response.data;
  }
  
  Future<List<Map<String, dynamic>>> listBackups() async {
    final response = await _dio.get('/api/backup');
    return List<Map<String, dynamic>>.from(response.data['backups'] ?? []);
  }
}
