import 'package:flutter/material.dart';
import 'package:spider_panel/models/inbound_model.dart';
import 'package:spider_panel/theme/app_theme.dart';

class InboundCard extends StatelessWidget {
  final Inbound inbound;
  final VoidCallback? onCopyJson;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEnable;
  final VoidCallback? onDisable;
  final NeonTheme? neon;

  const InboundCard({
    super.key,
    required this.inbound,
    this.onCopyJson,
    this.onEdit,
    this.onDelete,
    this.onEnable,
    this.onDisable,
    this.neon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    final colors = AppTheme.neonColors[effectiveNeon]!;
    final isActive = inbound.isActive && inbound.enable;
    
    return GlassCard(
      neon: effectiveNeon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getProtocolColor(inbound.protocol).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getProtocolIcon(inbound.protocol),
                  color: _getProtocolColor(inbound.protocol),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inbound.remark ?? 'Unnamed Inbound',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Port: ${inbound.port} • ${inbound.protocol.toUpperCase()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'Enabled' : 'Disabled',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Security',
                  value: inbound.security?.toUpperCase() ?? 'None',
                  icon: Icons.security,
                ),
              ),
              Expanded(
                child: _DetailItem(
                  label: 'Network',
                  value: inbound.network?.toUpperCase() ?? 'TCP',
                  icon: Icons.network_check,
                ),
              ),
              Expanded(
                child: _DetailItem(
                  label: 'Traffic',
                  value: _formatTraffic(inbound.trafficUsed),
                  icon: Icons.traffic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                icon: Icons.copy,
                label: 'JSON',
                onTap: onCopyJson,
                color: colors['primary']!,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.edit,
                label: 'Edit',
                onTap: onEdit,
                color: colors['primary']!,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.delete,
                label: 'Delete',
                onTap: onDelete,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              if (isActive)
                _ActionButton(
                  icon: Icons.toggle_off,
                  label: 'Disable',
                  onTap: onDisable,
                  color: Colors.orange,
                )
              else
                _ActionButton(
                  icon: Icons.toggle_on,
                  label: 'Enable',
                  onTap: onEnable,
                  color: Colors.green,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProtocolColor(String protocol) {
    switch (protocol.toLowerCase()) {
      case 'vless': return Colors.blue;
      case 'vmess': return Colors.purple;
      case 'trojan': return Colors.red;
      case 'shadowsocks': return Colors.orange;
      case 'socks': return Colors.teal;
      case 'http': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  IconData _getProtocolIcon(String protocol) {
    switch (protocol.toLowerCase()) {
      case 'vless':
      case 'vmess':
      case 'trojan':
      case 'shadowsocks':
        return Icons.vpn_key;
      case 'socks':
        return Icons.network_check;
      case 'http':
        return Icons.http;
      default:
        return Icons.settings;
    }
  }

  String _formatTraffic(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${bytes / 1024} KB';
  }

  NeonTheme _getCurrentNeon(ThemeData theme) {
    if (theme.colorScheme.primary.value == AppTheme.neonColors[NeonTheme.red]!['primary']!.value) {
      return NeonTheme.red;
    } else if (theme.colorScheme.primary.value == AppTheme.neonColors[NeonTheme.green]!['primary']!.value) {
      return NeonTheme.green;
    }
    return NeonTheme.blue;
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
