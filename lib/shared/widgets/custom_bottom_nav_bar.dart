import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final bool showLabels;
  final double height;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.showLabels = true,
    this.height = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Badge(
                        label: Text(
                          item.badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        isLabelVisible: item.badgeCount > 0,
                        child: Icon(
                          isSelected ? item.selectedIcon : item.icon,
                          color: isSelected
                              ? selectedItemColor ?? theme.primaryColor
                              : unselectedItemColor ?? theme.unselectedWidgetColor,
                        ),
                      ),
                      if (showLabels && item.label != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.label!,
                          style: TextStyle(
                            color: isSelected
                                ? selectedItemColor ?? theme.primaryColor
                                : unselectedItemColor ?? theme.unselectedWidgetColor,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Creates the default bottom navigation bar for the app
  static CustomBottomNavBar defaultNavBar({
    required int currentIndex,
    required BuildContext context,
  }) {
    return CustomBottomNavBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/categories');
            break;
          case 2:
            context.go('/cart');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: [
        CustomBottomNavItem(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Home',
        ),
        CustomBottomNavItem(
          icon: Icons.category_outlined,
          selectedIcon: Icons.category,
          label: 'Categories',
        ),
        CustomBottomNavItem(
          icon: Icons.shopping_cart_outlined,
          selectedIcon: Icons.shopping_cart,
          label: 'Cart',
          badgeCount: 0, // Update with actual cart count
        ),
        CustomBottomNavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profile',
        ),
      ],
    );
  }
}

class CustomBottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String? label;
  final int badgeCount;

  const CustomBottomNavItem({
    required this.icon,
    required this.selectedIcon,
    this.label,
    this.badgeCount = 0,
  });
}

/// Extension to add more navigation bar styles
extension CustomBottomNavBarStyles on CustomBottomNavBar {
  /// Creates a bottom navigation bar with a floating action button
  static Widget withFloatingButton({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<CustomBottomNavItem> items,
    required Widget floatingActionButton,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return Stack(
      children: [
        CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          backgroundColor: backgroundColor,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -30,
          child: Center(child: floatingActionButton),
        ),
      ],
    );
  }

  /// Creates a bottom navigation bar with curved design
  static Widget curved({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<CustomBottomNavItem> items,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return ClipPath(
      clipper: BottomNavClipper(),
      child: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        height: 70,
      ),
    );
  }
}

/// Clipper for curved bottom navigation bar
class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.25, 0);
    path.quadraticBezierTo(
      size.width * 0.5,
      -20,
      size.width * 0.75,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
