import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_cms_demo_app/shared/widgets/custom_text_input.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Widget? leading;
  final bool showSearchBar;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final bool showBorder;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double elevation;
  final Widget? bottom;
  final double? toolbarHeight;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.leading,
    this.showSearchBar = false,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.showBorder = true,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.elevation = 0,
    this.bottom,
    this.toolbarHeight,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (showBackButton && automaticallyImplyLeading) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    Widget? titleWidget;
    if (showSearchBar) {
      titleWidget = CustomTextInput.search(
        hint: searchHint ?? 'Search',
        onChanged: onSearchChanged,
        onTap: onSearchSubmitted,
      );
    } else if (title != null) {
      titleWidget = Text(
        title!,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return AppBar(
      leading: leadingWidget,
      title: titleWidget,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      systemOverlayStyle: systemOverlayStyle ??
          (theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light),
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: bottom!,
            )
          : null,
      toolbarHeight: toolbarHeight,
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? (bottom != null ? kToolbarHeight + 56 : kToolbarHeight),
      );

  /// Creates a search app bar
  static CustomAppBar search({
    String? hint,
    ValueChanged<String>? onSearchChanged,
    VoidCallback? onSearchSubmitted,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      showSearchBar: true,
      searchHint: hint,
      onSearchChanged: onSearchChanged,
      onSearchSubmitted: onSearchSubmitted,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }

  /// Creates a transparent app bar
  static CustomAppBar transparent({
    String? title,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: systemOverlayStyle,
      showBorder: false,
    );
  }

  /// Creates an app bar with bottom tabs
  static CustomAppBar withTabs({
    required String title,
    required List<Tab> tabs,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      bottom: TabBar(
        tabs: tabs,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates an app bar with a custom bottom widget
  static CustomAppBar withBottom({
    String? title,
    required Widget bottom,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      bottom: bottom,
    );
  }
}

/// Extension methods for common app bar configurations
extension CustomAppBarActions on CustomAppBar {
  /// Creates an app bar with cart and notification actions
  static List<Widget> commonActions({
    required BuildContext context,
    required VoidCallback onCartPressed,
    required VoidCallback onNotificationPressed,
    int cartItemCount = 0,
    int notificationCount = 0,
  }) {
    return [
      IconButton(
        icon: Badge(
          label: Text(
            cartItemCount.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          isLabelVisible: cartItemCount > 0,
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        onPressed: onCartPressed,
      ),
      IconButton(
        icon: Badge(
          label: Text(
            notificationCount.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          isLabelVisible: notificationCount > 0,
          child: const Icon(Icons.notifications_outlined),
        ),
        onPressed: onNotificationPressed,
      ),
    ];
  }

  /// Creates an app bar with a menu action
  static List<Widget> menuActions({
    required BuildContext context,
    required List<PopupMenuEntry<String>> items,
    required ValueChanged<String> onSelected,
  }) {
    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: onSelected,
        itemBuilder: (context) => items,
      ),
    ];
  }
}
