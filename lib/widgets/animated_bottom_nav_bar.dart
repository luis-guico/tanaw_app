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
    final Color backgroundColor = isGuardianMode
        ? const Color(0xFF103554)
        : const Color(0xDEFFFFFF);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(50),
            border: !isGuardianMode
                ? Border.all(color: Colors.grey.shade300)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  activeIcon: Icons.pie_chart,
                  inactiveIcon: Icons.pie_chart_outline,
                  label: 'Status',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                  isGuardianMode: isGuardianMode,
                ),
                _NavItem(
                  activeIcon: Icons.home,
                  inactiveIcon: Icons.home_outlined,
                  label: 'Home',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTapped(1),
                  isGuardianMode: isGuardianMode,
                ),
                _NavItem(
                  activeIcon: Icons.person,
                  inactiveIcon: Icons.person_outline,
                  label: 'Profile',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTapped(2),
                  isGuardianMode: isGuardianMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isGuardianMode;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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
    final Color activeColor =
        widget.isGuardianMode ? Colors.white : const Color(0xFF103554);
    final Color inactiveColor = const Color(0xFFB0B0B0);

    final color = widget.isSelected ? activeColor : inactiveColor;
    final iconData =
        widget.isSelected ? widget.activeIcon : widget.inactiveIcon;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: color),
              const SizedBox(height: 4),
              Text(widget.label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 5,
                width: 20,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? (widget.isGuardianMode
                          ? activeColor
                          : activeColor.withAlpha(50))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 