import 'package:flutter/material.dart';
import 'package:spider_panel/models/user_model.dart';
import 'package:spider_panel/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  final Client user;
  final VoidCallback? onQr;
  final VoidCallback? onCopy;
  final VoidCallback? onSubscribe;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final NeonTheme? neon;

  const UserCard({
    super.key,
    required this.user,
    this.onQr,
    this.onCopy,
    this.onSubscribe,
    this.onEdit,
    this.onDelete,
    this.onReset,
    this.neon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveNeon = neon ?? _getCurrentNeon(theme);
    final colors = AppTheme.neonColors[effectiveNeon]!;
    final isActive = user.isActive && user.status == 'active';
    final trafficPercent = user.trafficLimit > 0 
        ? user.trafficUsed / user.trafficLimit 
        : 0.0;
    
    return GlassCard(
      neon: effectiveNeon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors['primary']!.withOpacity(0.2),
                child: Icon(
                  isActive ? Icons.person : Icons.person_off,
                  color: colors['primary'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'UUID: ${user.uuid.substring(0, 8)}...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontFamily: 'monospace',
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
                  isActive ? 'Active' : 'Inactive',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'Inbound',
                  value: user.inboundId.substring(0, 8),
                  icon: Icons.router,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  label: 'Traffic',
                  value: _formatTraffic(user.trafficUsed),
                  icon: Icons.data_usage,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  label: 'Expires',
                  value: user.expireAt ?? 'Unlimited',
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
          if (user.trafficLimit > 0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: trafficPercent.clamp(0.0, 1.0),
                backgroundColor: colors['primary']!.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colors['primary']!),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(trafficPercent * 100).toStringAsFixed(1)}% used',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(icon: Icons.qr_code, label: 'QR', onTap: onQr, color: colors['primary']!),
              const SizedBox(width: 8),
              _ActionButton(icon: Icons.content_copy, label: 'Copy', onTap: onCopy, color: colors['primary']!),
              const SizedBox(width: 8),
              _ActionButton(icon: Icons.cloud_download, label: 'Sub', onTap: onSubscribe, color: colors['primary']!),
              const SizedBox(width: 8),
              _ActionButton(icon: Icons.edit, label: 'Edit', onTap: onEdit, color: colors['primary']!),
              const SizedBox(width: 8),
              _ActionButton(icon: Icons.delete, label: 'Del', onTap: onDelete, color: Colors.red),
              const SizedBox(width: 8),
              _ActionButton(icon: Icons.refresh, label: 'Reset', onTap: onReset, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTraffic(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
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

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({
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
          overflow: TextOverflow.ellipsis,
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
