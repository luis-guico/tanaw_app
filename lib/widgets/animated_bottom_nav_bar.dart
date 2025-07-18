import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class AnimatedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AnimatedBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;
    final Color backgroundColor =
        isGuardianMode ? const Color(0xFF14375F) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.show_chart,
                label: 'Status',
                isSelected: selectedIndex == 0,
                onTap: () => onItemTapped(0),
                isGuardianMode: isGuardianMode,
              ),
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 1,
                onTap: () => onItemTapped(1),
                isGuardianMode: isGuardianMode,
              ),
              _NavItem(
                icon: Icons.person,
                label: 'Profile',
                isSelected: selectedIndex == 2,
                onTap: () => onItemTapped(2),
                isGuardianMode: isGuardianMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isGuardianMode;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isGuardianMode,
  });

  @override
  __NavItemState createState() => __NavItemState();
}

class __NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(0, -0.2))
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor =
        widget.isGuardianMode ? Colors.white : const Color(0xFF153A5B);
    final Color unselectedColor =
        widget.isGuardianMode ? Colors.white.withAlpha(178) : Colors.grey[400]!;

    final color = widget.isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? selectedColor.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: color),
                const SizedBox(height: 4),
                Text(widget.label, style: TextStyle(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 