import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/services/api_service.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/services/storage_service.dart';
import 'package:spider_panel/models/dashboard_model.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final api = ref.watch(apiServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  return DashboardNotifier(api, storage);
});

class DashboardState {
  final bool isLoading;
  final DashboardStats? stats;
  final String? error;
  
  DashboardState({this.isLoading = false, this.stats, this.error});
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final ApiService _api;
  final StorageService _storage;
  
  DashboardNotifier(this._api, this._storage) : super(DashboardState()) {
    fetchDashboard();
  }
  
  Future<void> fetchDashboard() async {
    state = DashboardState(isLoading: true);
    try {
      final stats = await _api.getDashboard();
      await _storage.cacheDashboard(stats);
      state = DashboardState(isLoading: false, stats: stats);
    } catch (e) {
      final cached = _storage.getCachedDashboard();
      state = DashboardState(
        isLoading: false,
        stats: cached,
        error: cached == null ? e.toString() : null,
      );
    }
  }
}
