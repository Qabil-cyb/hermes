import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/services/api_service.dart';
import 'package:spider_panel/services/storage_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final storageServiceProvider = Provider((ref) => StorageService());

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final api = ref.watch(apiServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthStateNotifier(api, storage);
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? token;
  final String? error;
  final String? panelInfo;
  final String theme;
  final int? daysRemaining;
  
  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.token,
    this.error,
    this.panelInfo,
    this.theme = 'blue',
    this.daysRemaining,
  });
  
  AuthState copyWith({
    bool? isAuthenticated, bool? isLoading, String? token,
    String? error, String? panelInfo, String? theme, int? daysRemaining,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
    token: token ?? this.token,
    error: error,
    panelInfo: panelInfo ?? this.panelInfo,
    theme: theme ?? this.theme,
    daysRemaining: daysRemaining ?? this.daysRemaining,
  );
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final StorageService _storage;
  
  AuthStateNotifier(this._api, this._storage) : super(AuthState()) {
    _checkExistingAuth();
  }
  
  Future<void> _checkExistingAuth() async {
    final token = await _storage.getToken();
    final apiKey = await _storage.getApiKey();
    final baseUrl = await _storage.getBaseUrl();
    final theme = await _storage.getTheme() ?? 'blue';
    
    if (token != null && baseUrl != null) {
      _api.setBaseUrl(baseUrl);
      _api.setToken(token);
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        theme: theme,
      );
    } else if (apiKey != null && baseUrl != null) {
      _api.setBaseUrl(baseUrl);
    }
  }
  
  Future<void> login(String baseUrl, String apiKey, String deviceId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _api.setBaseUrl(baseUrl);
      final response = await _api.login(apiKey, deviceId);
      
      final token = response['access_token'] as String;
      _api.setToken(token);
      await _storage.saveToken(token);
      await _storage.saveApiKey(apiKey);
      await _storage.saveBaseUrl(baseUrl);
      await _storage.saveDeviceId(deviceId);
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        token: token,
        panelInfo: response['panel_info']?['name'] ?? 'Spider Panel',
        theme: response['theme'] ?? 'blue',
        daysRemaining: response['days_remaining'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> logout() async {
    await _storage.clearToken();
    await _storage.clearApiKey();
    _api.clearToken();
    state = AuthState();
  }
  
  Future<void> changeTheme(String theme) async {
    await _storage.saveTheme(theme);
    state = state.copyWith(theme: theme);
    _api.changeTheme(theme);
  }
}
