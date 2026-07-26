import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';
import 'package:spider_panel/screens/widgets/neon_button.dart';
import 'package:spider_panel/screens/widgets/glass_input.dart';
import 'package:spider_panel/services/api_service.dart';
import 'package:spider_panel/providers/theme_provider.dart';

class ProxyScreen extends ConsumerStatefulWidget {
  const ProxyScreen({super.key});

  @override
  ConsumerState<ProxyScreen> createState() => _ProxyScreenState();
}

class _ProxyScreenState extends ConsumerState<ProxyScreen> {
  List<Map<String, dynamic>> _proxies = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProxies();
  }

  Future<void> _loadProxies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final proxies = await api.getProxies();
      
      final proxyList = proxies.map((proxy) => {
        'id': proxy.id,
        'country': proxy.country ?? 'Unknown',
        'ip': proxy.ip,
        'port': proxy.port,
        'type': proxy.type,
        'status': proxy.status,
        'assignedUserId': proxy.assignedUserId,
      }).toList();

      setState(() {
        _proxies = proxyList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showAddProxyDialog() {
    final countryController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController();
    String selectedType = 'HTTP';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppTheme.neonColors[NeonTheme.blue]!['border']!,
              width: 1,
            ),
          ),
          title: Text(
            'Add Proxy',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassInput(
                  controller: countryController,
                  hint: 'Country',
                  prefixIcon: Icons.flag,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: ipController,
                  hint: 'IP Address',
                  prefixIcon: Icons.router,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: portController,
                  hint: 'Port',
                  prefixIcon: Icons.portable_wifi_off,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: selectedType,
                    dropdownColor: const Color(0xFF1A1A2E),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: TextStyle(color: Colors.white),
                    items: ['HTTP', 'HTTPS', 'SOCKS4', 'SOCKS5']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value ?? 'HTTP';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            NeonButton(
              label: 'Add',
              icon: Icons.add,
              isExpanded: true,
              onPressed: () async {
                try {
                  final api = ref.read(apiServiceProvider);
                  await api.addProxy(
                    countryController.text.trim(),
                    ipController.text.trim(),
                    int.tryParse(portController.text) ?? 8080,
                    selectedType,
                  );
                  Navigator.pop(context);
                  _loadProxies();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Proxy added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add proxy: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ).then((_) {
      countryController.dispose();
      ipController.dispose();
      portController.dispose();
    });
  }

  void _showAssignProxyDialog(Map<String, dynamic> proxy) {
    final userController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.neonColors[NeonTheme.blue]!['border']!,
            width: 1,
          ),
        ),
        title: Text(
          'Assign Proxy to User',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Proxy: ${proxy['ip']}:${proxy['port']} (${proxy['country']})',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            GlassInput(
              controller: userController,
              hint: 'User ID',
              prefixIcon: Icons.person,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          NeonButton(
            label: 'Assign',
            icon: Icons.link,
            isExpanded: true,
            onPressed: () async {
              try {
                final api = ref.read(apiServiceProvider);
                await api.assignProxy(userController.text.trim(), proxy['id']);
                Navigator.pop(context);
                _loadProxies();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Proxy assigned successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to assign proxy: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    ).then((_) => userController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = ref.watch(customThemeProvider);
    final neonColor = AppTheme.neonColors[customTheme]!['primary']!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F0F1A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'IP Proxy',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProxies,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.white38),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load proxies',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadProxies,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _proxies.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.vpn_lock_outlined, size: 64, color: Colors.white38),
                              const SizedBox(height: 16),
                              Text(
                                'No proxies configured',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a proxy to get started',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              NeonButton(
                                label: 'Add Proxy',
                                icon: Icons.add,
                                onPressed: _showAddProxyDialog,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _proxies.length,
                          itemBuilder: (context, index) {
                            final proxy = _proxies[index];
                            final statusColor = proxy['status'] == 'active' ? Colors.green : Colors.red;

                            return GlassCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: statusColor.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.vpn_lock,
                                          color: statusColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  proxy['ip'],
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    ':${proxy['port']}',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.flag, size: 14, color: Colors.white60),
                                                const SizedBox(width: 4),
                                                Text(
                                                  proxy['country'],
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Icon(Icons.category, size: 14, color: Colors.white60),
                                                const SizedBox(width: 4),
                                                Text(
                                                  proxy['type'],
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: statusColor.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          proxy['status'].toUpperCase(),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (proxy['assignedUserId'] == null)
                                        TextButton.icon(
                                          onPressed: () => _showAssignProxyDialog(proxy),
                                          icon: Icon(Icons.person_add, size: 16, color: neonColor),
                                          label: Text('Assign to User', style: TextStyle(color: neonColor)),
                                        )
                                      else
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.blue.withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.person, size: 14, color: Colors.blue[300]),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Assigned',
                                                style: TextStyle(
                                                  color: Colors.blue[300],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(
                              delay: Duration(milliseconds: index * 50),
                            ).slideX(begin: 0.2, end: 0);
                          },
                        ),
        ),
        floatingActionButton: NeonFAB(
          icon: Icons.add,
          onPressed: _showAddProxyDialog,
        ),
      ),
    );
  }
}