import 'dart:convert';

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

class AIScreen extends ConsumerStatefulWidget {
  const AIScreen({super.key});

  @override
  ConsumerState<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends ConsumerState<AIScreen> {
  bool _isHermesInstalled = false;
  bool _isInstalling = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _messages = [];
  final _messageController = TextEditingController();
  String? _conversationId;


  ThemeData get theme => Theme.of(context);
  Color get neonColor => AppTheme.neonColors[ref.watch(customThemeProvider)]!['primary']!;
  NeonTheme get customTheme => ref.watch(customThemeProvider);
  @override
  void initState() {
    super.initState();
    _checkHermesStatus();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _checkHermesStatus() async {
    // In a real app, this would check if Hermes is installed
    // For now, we'll simulate it
    setState(() {
      _isHermesInstalled = false; // Change to true to test chat interface
    });
  }

  Future<void> _installHermes() async {
    setState(() => _isInstalling = true);
    
    try {
      final api = ref.read(apiServiceProvider);
      await api.installHermes();
      
      if (mounted) {
        setState(() {
          _isHermesInstalled = true;
          _isInstalling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hermes AI installed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInstalling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to install Hermes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'content': message,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.chatWithHermes(message, _conversationId);
      
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': response['response'] ?? 'No response',
          'timestamp': DateTime.now(),
        });
        _conversationId = response['conversation_id'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Error: $e',
          'timestamp': DateTime.now(),
          'isError': true,
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ref.watch(customThemeProvider);

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
            'Hermes AI',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: _isHermesInstalled ? _buildChatInterface() : _buildInstallScreen(),
        ),
      ),
    );
  }

  Widget _buildInstallScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    neonColor.withOpacity(0.3),
                    neonColor.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonColors[customTheme]!['glow']!.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.psychology,
                size: 80,
                color: neonColor,
              ),
            ).animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 2000.ms),
            
            const SizedBox(height: 32),
            
            Text(
              'Hermes AI Assistant',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Text(
              'Your intelligent AI companion for managing Spider Panel. Ask questions, get help with configurations, analyze traffic patterns, and more.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 40),
            
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_download,
                    size: 48,
                    color: neonColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Install Hermes AI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will install the Hermes AI service on your server. The process may take a few minutes.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  NeonButton(
                    label: _isInstalling ? 'Installing...' : 'Turn On Hermes',
                    icon: _isInstalling ? null : Icons.power_settings_new,
                    isLoading: _isInstalling,
                    isExpanded: true,
                    onPressed: _isInstalling ? null : _installHermes,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).scale(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white38),
                      const SizedBox(height: 16),
                      Text(
                        'Start a conversation with Hermes',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ask me anything about your panel',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    return _buildMessageBubble(message).animate()
                      .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 30))
                      .slideY(begin: 0.2, end: 0);
                  },
                ),
        ),
        
        // Loading indicator
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: neonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(neonColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hermes is thinking...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        
        // Input area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: GlassInput(
                    controller: _messageController,
                    hint: 'Ask Hermes...',
                    prefixIcon: Icons.message,
                    onSuffixPressed: _sendMessage,
                    suffixIcon: Icons.send,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 12),
                NeonIconButton(
                  icon: Icons.send,
                  onPressed: _sendMessage,
                  color: neonColor,
                  size: 56,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';
    final isError = message['isError'] == true;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUser
                ? [
                    neonColor.withOpacity(0.3),
                    neonColor.withOpacity(0.1),
                  ]
                : isError
                    ? [
                        Colors.red.withOpacity(0.2),
                        Colors.red.withOpacity(0.05),
                      ]
                    : [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
          ),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
          ),
          border: Border.all(
            color: isUser
                ? neonColor.withOpacity(0.5)
                : isError
                    ? Colors.red.withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'] ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isError ? Colors.red[300] : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(message['timestamp'] as DateTime?),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}