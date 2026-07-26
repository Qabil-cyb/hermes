import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';
import 'package:spider_panel/screens/widgets/inbound_card.dart';
import 'package:spider_panel/screens/widgets/neon_button.dart';
import 'package:spider_panel/screens/widgets/glass_input.dart';
import 'package:spider_panel/services/api_service.dart';
import 'dart:convert';

class InboundsScreen extends ConsumerStatefulWidget {
  const InboundsScreen({super.key});

  @override
  ConsumerState<InboundsScreen> createState() => _InboundsScreenState();
}

class _InboundsScreenState extends ConsumerState<InboundsScreen> {
  List<Map<String, dynamic>> _inbounds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInbounds();
  }

  Future<void> _loadInbounds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final inbounds = await api.getInbounds();
      
      final inboundList = inbounds.map((inbound) => {
        'id': inbound.id,
        'remark': inbound.remark ?? 'Unnamed',
        'port': inbound.port,
        'protocol': inbound.protocol,
        'security': inbound.security,
        'network': inbound.network,
        'enable': inbound.enable,
        'isActive': inbound.isActive,
        'trafficUsed': inbound.trafficUsed,
        'settings': inbound.settings,
        'streamSettings': inbound.streamSettings,
      }).toList();

      setState(() {
        _inbounds = inboundList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCreateInboundDialog() {
    final remarkController = TextEditingController();
    final portController = TextEditingController();
    String selectedProtocol = 'vless';
    String selectedNetwork = 'tcp';
    String selectedSecurity = 'none';

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
            'Create New Inbound',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassInput(
                  controller: remarkController,
                  hint: 'Remark',
                  prefixIcon: Icons.label,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: portController,
                  hint: 'Port',
                  prefixIcon: Icons.router,
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
                    value: selectedProtocol,
                    dropdownColor: const Color(0xFF1A1A2E),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: TextStyle(color: Colors.white),
                    items: ['vless', 'vmess', 'trojan', 'shadowsocks']
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedProtocol = value ?? 'vless';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: selectedNetwork,
                    dropdownColor: const Color(0xFF1A1A2E),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: TextStyle(color: Colors.white),
                    items: ['tcp', 'ws', 'grpc', 'http', 'kcp']
                        .map((n) => DropdownMenuItem(
                              value: n,
                              child: Text(n.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedNetwork = value ?? 'tcp';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: selectedSecurity,
                    dropdownColor: const Color(0xFF1A1A2E),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: TextStyle(color: Colors.white),
                    items: ['none', 'tls', 'reality']
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedSecurity = value ?? 'none';
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
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            NeonButton(
              label: 'Create',
              icon: Icons.add,
              isExpanded: true,
              onPressed: () async {
                try {
                  final api = ref.read(apiServiceProvider);
                  await api.createInbound({
                    'remark': remarkController.text.trim(),
                    'port': int.tryParse(portController.text) ?? 0,
                    'protocol': selectedProtocol,
                    'network': selectedNetwork,
                    'security': selectedSecurity,
                  });
                  Navigator.pop(context);
                  _loadInbounds();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Inbound created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create inbound: $e'),
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
      remarkController.dispose();
      portController.dispose();
    });
  }

  void _showInboundJson(String id) async {
    try {
      final api = ref.read(apiServiceProvider);
      final json = await api.getInboundJson(id);
      
      if (context.mounted) {
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
              'Inbound JSON',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              width: double.maxFinite,
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
              child: SingleChildScrollView(
                child: SelectableText(
                  const JsonEncoder.withIndent('  ').convert(json),
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get JSON: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            'Inbounds',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadInbounds,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.white38),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load inbounds',
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
                            onPressed: _loadInbounds,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _inbounds.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.white38),
                              const SizedBox(height: 16),
                              Text(
                                'No inbounds found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadInbounds,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _inbounds.length,
                            itemBuilder: (context, index) {
                              final inbound = _inbounds[index];
                              return InboundCard(
                                inbound: inbound,
                                onCopyJsonPressed: () => _showInboundJson(inbound['id']),
                                onEditPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Edit inbound: ${inbound['remark']}'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  );
                                },
                                onDeletePressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color(0xFF1A1A2E),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: AppTheme.neonColors[NeonTheme.red]!['border']!,
                                          width: 1,
                                        ),
                                      ),
                                      title: Text('Delete Inbound', style: TextStyle(color: Colors.white)),
                                      content: Text(
                                        'Are you sure you want to delete "${inbound['remark']}"?',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: AppTheme.neonColors[NeonTheme.red]!['primary']!,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    try {
                                      final api = ref.read(apiServiceProvider);
                                      await api.deleteInbound(inbound['id']);
                                      _loadInbounds();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Inbound deleted'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to delete: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                onEnablePressed: () async {
                                  try {
                                    final api = ref.read(apiServiceProvider);
                                    await api.enableInbound(inbound['id']);
                                    _loadInbounds();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to enable: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                onDisablePressed: () async {
                                  try {
                                    final api = ref.read(apiServiceProvider);
                                    await api.disableInbound(inbound['id']);
                                    _loadInbounds();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to disable: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ).animate().fadeIn(
                                delay: Duration(milliseconds: index * 50),
                              ).slideX(begin: 0.3, end: 0);
                            },
                          ),
                        ),
        ),
        floatingActionButton: NeonFAB(
          icon: Icons.add,
          onPressed: _showCreateInboundDialog,
        ),
      ),
    );
  }
}