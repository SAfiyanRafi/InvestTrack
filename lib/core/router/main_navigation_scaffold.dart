import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A responsive shell that wraps the application's primary screens with either
/// a bottom navigation bar or a side navigation rail depending on device size.
class MainNavigationScaffold extends StatelessWidget {
  const MainNavigationScaffold({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell containing the active child screen branch.
  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 800;

    // Define navigation destinations/items
    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.business_outlined),
        selectedIcon: Icon(Icons.business),
        label: 'Businesses',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Transactions',
      ),
      NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: 'Analytics',
      ),
      NavigationDestination(
        icon: Icon(Icons.analytics_outlined),
        selectedIcon: Icon(Icons.analytics),
        label: 'Reports',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: theme.navigationBarTheme.backgroundColor,
              extended: size.width >= 1100,
              minWidth: 72,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: size.width >= 1100
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              leading: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              destinations: destinations.map((dest) {
                return NavigationRailDestination(
                  icon: dest.icon,
                  selectedIcon: dest.selectedIcon,
                  label: Text(dest.label),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: navigationShell,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _MobileNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

class _MobileNavigationBar extends StatelessWidget {
  const _MobileNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final items = <_NavItemData>[
      const _NavItemData(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
      ),
      const _NavItemData(
        label: 'Businesses',
        icon: Icons.business_outlined,
        selectedIcon: Icons.business,
      ),
      const _NavItemData(
        label: 'Transactions',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
      ),
      const _NavItemData(
        label: 'Analytics',
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
      ),
      const _NavItemData(
        label: 'Reports',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
      ),
      const _NavItemData(
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.18),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _MobileNavigationDestination(
                  item: items[index],
                  isSelected: index == currentIndex,
                  onTap: () => onDestinationSelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavigationDestination extends StatelessWidget {
  const _MobileNavigationDestination({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.68);
    final foregroundColor = isSelected ? selectedColor : unselectedColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? selectedColor.withValues(alpha: 0.10)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                size: 20,
                color: foregroundColor,
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 14,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    softWrap: false,
                    maxLines: 1,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foregroundColor,
                      fontSize: 10,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
