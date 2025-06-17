import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  error,
  success
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height = 48.0,
    this.margin,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define style configurations based on variant
    ButtonStyle getButtonStyle() {
      switch (variant) {
        case ButtonVariant.primary:
          return ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
        case ButtonVariant.secondary:
          return ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
        case ButtonVariant.outline:
          return OutlinedButton.styleFrom(
            foregroundColor: theme.primaryColor,
            side: BorderSide(color: theme.primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
        case ButtonVariant.text:
          return TextButton.styleFrom(
            foregroundColor: theme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
        case ButtonVariant.error:
          return ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
        case ButtonVariant.success:
          return ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          );
      }
    }

    // Build button child based on state
    Widget buildChild() {
      if (isLoading) {
        return SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              variant == ButtonVariant.outline ? theme.primaryColor : Colors.white,
            ),
          ),
        );
      }

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        );
      }

      return Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    }

    // Build the button widget
    Widget button = SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : width,
      child: variant == ButtonVariant.outline
          ? OutlinedButton(
              onPressed: disabled || isLoading ? null : onPressed,
              style: getButtonStyle(),
              child: buildChild(),
            )
          : variant == ButtonVariant.text
              ? TextButton(
                  onPressed: disabled || isLoading ? null : onPressed,
                  style: getButtonStyle(),
                  child: buildChild(),
                )
              : ElevatedButton(
                  onPressed: disabled || isLoading ? null : onPressed,
                  style: getButtonStyle(),
                  child: buildChild(),
                ),
    );

    // Apply margin if specified
    if (margin != null) {
      button = Padding(
        padding: margin!,
        child: button,
      );
    }

    return button;
  }
}

/// Extension methods for CustomButton variants
extension CustomButtonVariants on CustomButton {
  /// Creates a primary button
  static CustomButton primary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
    double? width,
    double height = 48.0,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      width: width,
      height: height,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Creates a secondary button
  static CustomButton secondary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
    double? width,
    double height = 48.0,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      width: width,
      height: height,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Creates an outline button
  static CustomButton outline({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
    double? width,
    double height = 48.0,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      width: width,
      height: height,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Creates a text button
  static CustomButton text({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      isLoading: isLoading,
      icon: icon,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Creates an error button
  static CustomButton error({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
    double? width,
    double height = 48.0,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.error,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      width: width,
      height: height,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Creates a success button
  static CustomButton success({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
    double? width,
    double height = 48.0,
    EdgeInsets? margin,
    bool disabled = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.success,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      width: width,
      height: height,
      margin: margin,
      disabled: disabled,
    );
  }
}
