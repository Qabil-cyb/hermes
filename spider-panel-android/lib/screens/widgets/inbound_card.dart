import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InboundCard extends StatelessWidget {
  final Map<String, dynamic> inbound;
  final VoidCallback? onCopyJsonPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEnablePressed;
  final VoidCallback? onDisablePressed;
  final Animation<double>? animation;

  const InboundCard({
    super.key,
    required this.inbound,
    this.onCopyJsonPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onEnablePressed,
    this.onDisablePressed,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = inbound['enable'] == true || inbound['isActive'] == true;
    final statusColor = isActive ? Colors.green : Colors.red;
    final statusText = isActive ? 'ACTIVE' : 'DISABLED';

    Widget card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  inbound['remark'] ?? 'Unnamed Inbound',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: statusColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.router,
                  label: 'Port',
                  value: inbound['port']?.toString() ?? 'N/A',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.security,
                  label: 'Protocol',
                  value: inbound['protocol'] ?? 'N/A',
                  theme: theme,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.security_update,
                  label: 'Security',
                  value: inbound['security'] ?? 'N/A',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.network_check,
                  label: 'Network',
                  value: inbound['network'] ?? 'N/A',
                  theme: theme,
                ),
              ),
            ],
          ),
          
          if (inbound['trafficUsed'] != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.data_usage,
                    label: 'Traffic Used',
                    value: _formatBytes(inbound['trafficUsed']),
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.copy,
                label: 'Copy JSON',
                color: Colors.blue,
                onPressed: onCopyJsonPressed,
              ),
              _buildActionButton(
                icon: Icons.edit,
                label: 'Edit',
                color: Colors.teal,
                onPressed: onEditPressed,
              ),
              _buildActionButton(
                icon: Icons.delete,
                label: 'Delete',
                color: Colors.red,
                onPressed: onDeletePressed,
              ),
              if (isActive)
                _buildActionButton(
                  icon: Icons.block,
                  label: 'Disable',
                  color: Colors.orange,
                  onPressed: onDisablePressed,
                )
              else
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Enable',
                  color: Colors.green,
                  onPressed: onEnablePressed,
                ),
            ],
          ),
        ],
      ),
    );

    if (animation != null) {
      card = FadeTransition(
        opacity: animation!,
        child: card,
      );
    }

    return card;
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white60),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}