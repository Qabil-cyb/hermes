import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onQRPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onSubscriptionPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onResetTrafficPressed;
  final Animation<double>? animation;

  const UserCard({
    super.key,
    required this.user,
    this.onQRPressed,
    this.onCopyPressed,
    this.onSubscriptionPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onResetTrafficPressed,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
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
                  user['username'] ?? 'Unknown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (user['status'] == 'active')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(Icons.fingerprint, size: 16, color: Colors.white60),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user['uuid'] ?? 'No UUID',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 16, color: Colors.white70),
                onPressed: onCopyPressed,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(Icons.groups, size: 16, color: Colors.white60),
              const SizedBox(width: 8),
              Text(
                user['inbound'] ?? 'N/A',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.data_usage, size: 16, color: Colors.white60),
                  const SizedBox(width: 8),
                  Text(
                    '${user['traffic'] ?? '0'} / ${user['trafficLimit'] ?? '0'} GB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    user['expire'] ?? 'N/A',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: (user['expire']?.contains('expired') == true) 
                          ? Colors.red 
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.qr_code,
                label: 'QR',
                color: Colors.blue,
                onPressed: onQRPressed,
              ),
              _buildActionButton(
                icon: Icons.copy_all,
                label: 'Copy',
                color: Colors.purple,
                onPressed: onCopyPressed,
              ),
              _buildActionButton(
                icon: Icons.link,
                label: 'Sub',
                color: Colors.orange,
                onPressed: onSubscriptionPressed,
              ),
              _buildActionButton(
                icon: Icons.edit,
                label: 'Edit',
                color: Colors.teal,
                onPressed: onEditPressed,
              ),
              _buildActionButton(
                icon: Icons.delete,
                label: 'Del',
                color: Colors.red,
                onPressed: onDeletePressed,
              ),
              _buildActionButton(
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.indigo,
                onPressed: onResetTrafficPressed,
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
}