import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spider_panel/providers/dashboard_provider.dart';
import 'package:spider_panel/widgets/stat_card.dart';
import 'package:spider_panel/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final dashboardNotifier = ref.read(dashboardProvider.notifier);
    final theme = Theme.of(context);
    final neon = Theme.of(context).brightness == Brightness.dark 
        ? NeonTheme.blue 
        : NeonTheme.red;
    
    // Fetch dashboard data
    ref.once(dashboardNotifier.fetchDashboard);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: dashboardNotifier.fetchDashboard,
          ),
        ],
      ),
      body: dashboardState.stats == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // System Stats Grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    children: [
                      // CPU Card
                      StatCard(
                        label: 'CPU',
                        value: '${dashboardState.stats!.cpuPercent.toStringAsFixed(1)}%',
                        icon: Icons.cpu,
                        iconColor: Colors.orange,
                        progress: dashboardState.stats!.cpuPercent / 100,
                        subtitle: 'Threads: ${dashboardState.stats!.cpuCount}',
                        neon: neon,
                      ),
                      
                      // RAM Card
                      StatCard(
                        label: 'RAM',
                        value: _formatBytes(dashboardState.stats!.ramUsed),
                        icon: Icons.memory,
                        iconColor: Colors.blue,
                        progress: dashboardState.stats!.ramPercent / 100,
                        subtitle: 'Total: ${_formatBytes(dashboardState.stats!.ramTotal)}',
                        neon: neon,
                      ),
                      
                      // Disk Card
                      StatCard(
                        label: 'Storage',
                        value: _formatBytes(dashboardState.stats!.diskUsed),
                        icon: Icons.sd_storage,
                        iconColor: Colors.green,
                        progress: dashboardState.stats!.diskPercent / 100,
                        subtitle: 'Total: ${_formatBytes(dashboardState.stats!.diskTotal)}',
                        neon: neon,
                      ),
                      
                      // Network Card
                      StatCard(
                        label: 'Network',
                        value: _formatBytes(dashboardState.stats!.networkSentBytes),
                        icon: Icons.network_check,
                        iconColor: Colors.purple,
                        subtitle: 'Uplink: ${_formatBytes(dashboardState.stats!.networkRecvBytes)}',
                        neon: neon,
                      ),
                      
                      // Users Online Card
                      StatCard(
                        label: 'Online Users',
                        value: dashboardState.stats!.usersOnline.toString(),
                        icon: Icons.people,
                        iconColor: Colors.teal,
                        subtitle: 'Total: ${dashboardState.stats!.usersTotal}',
                        neon: neon,
                      ),
                      
                      // Inbounds Card
                      StatCard(
                        label: 'Enabled Inbounds',
                        value: dashboardState.stats!.inboundsEnabled.toString(),
                        icon: Icons.router,
                        iconColor: Colors.indigo,
                        subtitle: 'Disabled: ${dashboardState.stats!.inboundsDisabled}',
                        neon: neon,
                      ),
                      
                      // Load Average Card
                      StatCard(
                        label: 'Load Average',
                        value: dashboardState.stats!.loadAverage1m.toStringAsFixed(2),
                        icon: Icons.speed,
                        iconColor: Colors.cyan,
                        subtitle: '1m: ${dashboardState.stats!.loadAverage1m.toStringAsFixed(2)} | 5m: ${dashboardState.stats!.loadAverage5m.toStringAsFixed(2)}',
                        neon: neon,
                      ),
                      
                      // Uptime Card
                      StatCard(
                        label: 'Server Uptime',
                        value: dashboardState.stats!.serverUptime,
                        icon: Icons.timer,
                        iconColor: Colors.amber,
                        subtitle: 'Since boot',
                        neon: neon,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional Info Cards
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    children: [
                      // Temperature Card
                      if (dashboardState.stats!.temperature != null)
                        StatCard(
                          label: 'Temperature',
                          value: '${dashboardState.stats!.temperature!.toStringAsFixed(1)}°C',
                          icon: Icons.thermostat,
                          iconColor: Colors.red,
                          neon: neon,
                        ),
                      
                      // Docker Card
                      if (dashboardState.stats!.dockerContainers > 0)
                        StatCard(
                          label: 'Docker Containers',
                          value: dashboardState.stats!.dockerContainers.toString(),
                          icon: Icons.containerized_workspaces,
                          iconColor: Colors.blueGrey,
                          neon: neon,
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)} TB';
    } else if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
  }
}
