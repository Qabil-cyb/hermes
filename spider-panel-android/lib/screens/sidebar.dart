import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF0F0F1A),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo section
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.spa,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SPIDER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(
              color: Colors.white24,
              height: 1,
              indent: 24,
              endIndent: 24,
            ),
            
            const SizedBox(height: 16),
            
            // Navigation items
            _buildNavItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              index: 0,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.people,
              label: 'Users',
              index: 1,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.inbox,
              label: 'Inbounds',
              index: 2,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.psychology,
              label: 'AI',
              index: 3,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.article,
              label: 'News',
              index: 4,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.vpn_lock,
              label: 'IP Proxy',
              index: 5,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            _buildNavItem(
              icon: Icons.settings,
              label: 'Settings',
              index: 6,
              selectedIndex: selectedIndex,
              onTap: onTabSelected,
            ),
            const Spacer(),
            
            // Contact Me
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Made by Amir',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon;
    required String label;
    required int index;
    required int selectedIndex;
    required Function(int) onTap;
  }) {
    final isSelected = selectedIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}