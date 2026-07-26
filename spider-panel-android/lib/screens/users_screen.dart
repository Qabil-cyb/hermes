import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';
import 'package:spider_panel/screens/widgets/user_card.dart';
import 'package:spider_panel/screens/widgets/neon_button.dart';
import 'package:spider_panel/screens/widgets/glass_input.dart';
import 'package:spider_panel/services/api_service.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final clients = await api.getUsers(limit: 100, search: _searchQuery);
      
      final users = clients.map((client) => {
        'id': client.id,
        'username': client.username,
        'uuid': client.uuid,
        'inbound': client.inboundId,
        'traffic': (client.trafficUsed / 1024 / 1024 / 1024).toStringAsFixed(1),
        'trafficLimit': (client.trafficLimit / 1024 / 1024 / 1024).toStringAsFixed(0),
        'status': client.status,
        'expire': client.expireAt ?? 'Never',
        'description': client.description ?? '',
      }).toList();

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCreateUserDialog() {
    final usernameController = TextEditingController();
    final trafficController = TextEditingController();
    final expireController = TextEditingController(text: '30');
    final descriptionController = TextEditingController();
    String selectedInbound = '';
    int ipLimit = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppTheme.neonColors[NeonTheme.blue]['border']!,
              width: 1,
            ),
          ),
          title: Text(
            'Create New User',
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
                  controller: usernameController,
                  hint: 'Username',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: trafficController,
                  hint: 'Traffic Limit (GB)',
                  prefixIcon: Icons.data_usage,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: expireController,
                  hint: 'Expire Days',
                  prefixIcon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: descriptionController,
                  hint: 'Description',
                  prefixIcon: Icons.description,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: selectedInbound.isEmpty ? null : selectedInbound,
                    hint: Text(
                      'Select Inbound',
                      style: TextStyle(color: Colors.white70),
                    ),
                    dropdownColor: const Color(0xFF1A1A2E),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'vless-1', child: Text('VLESS TCP')),
                      DropdownMenuItem(value: 'vmess-1', child: Text('VMess WS')),
                      DropdownMenuItem(value: 'trojan-1', child: Text('Trojan GRPC')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedInbound = value ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'IP Limit: $ipLimit',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.white),
                          onPressed: ipLimit > 1
                              ? () => setDialogState(() => ipLimit--)
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: ipLimit < 10
                              ? () => setDialogState(() => ipLimit++)
                              : null,
                        ),
                      ],
                    ),
                  ],
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
              icon: Icons.person_add,
              isExpanded: true,
              onPressed: selectedInbound.isEmpty
                  ? null
                  : () async {
                      try {
                        final api = ref.read(apiServiceProvider);
                        await api.createUser(
                          username: usernameController.text.trim(),
                          inboundId: selectedInbound,
                          trafficLimit: int.tryParse(trafficController.text) ?? 0,
                          expireDays: int.tryParse(expireController.text) ?? 30,
                          ipLimit: ipLimit,
                          description: descriptionController.text.trim(),
                        );
                        Navigator.pop(context);
                        _loadUsers();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User created successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to create user: $e'),
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
      usernameController.dispose();
      trafficController.dispose();
      expireController.dispose();
      descriptionController.dispose();
    });
  }

  void _deleteUser(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.neonColors[NeonTheme.red]['border']!,
            width: 1,
          ),
        ),
        title: Text(
          'Delete User',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete this user?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              try {
                final api = ref.read(apiServiceProvider);
                await api.deleteUser(id);
                Navigator.pop(context);
                _loadUsers();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete user: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.neonColors[NeonTheme.red]['primary'],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
            'Users',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadUsers,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassInput(
                  hint: 'Search users...',
                  prefixIcon: Icons.search,
                  suffixIcon: Icons.clear,
                  onSuffixPressed: () {
                    setState(() => _searchQuery = '');
                    _loadUsers();
                  },
                  onChanged: (value) {
                    setState(() => _searchQuery = value ?? '');
                  },
                ),
              ),
              
              // Users list
              Expanded(
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
                                  'Failed to load users',
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
                                  onPressed: _loadUsers,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : _users.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.people_outline, size: 64, color: Colors.white38),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No users found',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadUsers,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: _users.length,
                                  itemBuilder: (context, index) {
                                    final user = _users[index];
                                    return UserCard(
                                      user: user,
                                      onQRPressed: () {
                                        // Show QR code
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('QR Code: ${user['username']}'),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        );
                                      },
                                      onCopyPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('UUID copied: ${user['uuid']}'),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        );
                                      },
                                      onSubscriptionPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Subscription link copied'),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        );
                                      },
                                      onEditPressed: () {
                                        // Edit user
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Edit user: ${user['username']}'),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        );
                                      },
                                      onDeletePressed: () => _deleteUser(user['id']),
                                      onResetTrafficPressed: () async {
                                        try {
                                          final api = ref.read(apiServiceProvider);
                                          await api.resetUserTraffic(user['id']);
                                          _loadUsers();
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Traffic reset for ${user['username']}'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Failed to reset traffic: $e'),
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
            ],
          ),
        ),
        floatingActionButton: NeonFAB(
          icon: Icons.person_add,
          onPressed: _showCreateUserDialog,
        ),
      ),
    );
  }
}