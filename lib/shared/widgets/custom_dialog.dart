import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/shared/widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? content;
  final bool showCloseButton;
  final bool barrierDismissible;
  final Color? confirmButtonColor;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const CustomDialog({
    Key? key,
    this.title,
    this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.content,
    this.showCloseButton = true,
    this.barrierDismissible = true,
    this.confirmButtonColor,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                showCloseButton ? 0 : 24,
                24,
                24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 48,
                      color: iconColor ?? theme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (title != null) ...[
                    Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (message != null)
                    Text(
                      message!,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  if (content != null) content!,
                  if (onConfirm != null || onCancel != null) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        if (onCancel != null)
                          Expanded(
                            child: CustomButton(
                              text: cancelText ?? 'Cancel',
                              onPressed: () {
                                Navigator.of(context).pop();
                                onCancel?.call();
                              },
                              variant: ButtonVariant.outline,
                            ),
                          ),
                        if (onCancel != null && onConfirm != null)
                          const SizedBox(width: 16),
                        if (onConfirm != null)
                          Expanded(
                            child: CustomButton(
                              text: confirmText ?? 'OK',
                              onPressed: () {
                                Navigator.of(context).pop();
                                onConfirm?.call();
                              },
                              variant: isDestructive
                                  ? ButtonVariant.error
                                  : ButtonVariant.primary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title ?? 'Success',
        message: message,
        confirmText: buttonText ?? 'OK',
        onConfirm: onPressed,
        icon: Icons.check_circle,
        iconColor: Colors.green,
      ),
    );
  }

  /// Shows an error dialog
  static Future<void> showError({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title ?? 'Error',
        message: message,
        confirmText: buttonText ?? 'OK',
        onConfirm: onPressed,
        icon: Icons.error,
        iconColor: Colors.red,
      ),
    );
  }

  /// Shows a confirmation dialog
  static Future<bool> showConfirmation({
    required BuildContext context,
    String? title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        title: title ?? 'Confirm',
        message: message,
        confirmText: confirmText ?? 'Confirm',
        cancelText: cancelText ?? 'Cancel',
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
        icon: isDestructive ? Icons.warning : Icons.help,
        iconColor: isDestructive ? Colors.red : Colors.orange,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  /// Shows a custom content dialog
  static Future<T?> showCustom<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCloseButton = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCloseButton: showCloseButton,
      ),
    );
  }

  /// Shows a loading dialog
  static Future<void> showLoading({
    required BuildContext context,
    String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
