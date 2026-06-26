import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'analytics_screen.dart';
import 'budget_screen.dart';
import 'money_flow_screen.dart';
import 'new_record_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _pages = [
    MoneyFlowScreen(),
    NewRecordScreen(),
    AnalyticsScreen(),
    BudgetScreen(),
    SettingsScreen(),
  ];

  static const _items = [
    _NavigationItem(icon: Icons.account_balance_wallet_rounded, label: 'Flow'),
    _NavigationItem(icon: Icons.add_circle_outline_rounded, label: 'Record'),
    _NavigationItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
    _NavigationItem(icon: Icons.savings_rounded, label: 'Budget'),
    _NavigationItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = _selectedIndex == index;
              return Expanded(
                child: _BottomNavButton(
                  item: item,
                  selected: selected,
                  onTap: () => setState(() => _selectedIndex = index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.16) : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: selected ? AppColors.primaryDark : AppColors.muted,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? AppColors.primaryDark : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
