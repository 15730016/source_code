import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final Widget? suffix;
  final EdgeInsets? contentPadding;
  final bool autofocus;
  final String? initialValue;
  final bool showClear;
  final Color? fillColor;
  final String? helperText;
  final int? maxLength;
  final bool showCounter;

  const CustomTextInput({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffix,
    this.contentPadding,
    this.autofocus = false,
    this.initialValue,
    this.showClear = false,
    this.fillColor,
    this.helperText,
    this.maxLength,
    this.showCounter = false,
  }) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late TextEditingController _controller;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText && !_showPassword,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          autofocus: widget.autofocus,
          maxLength: widget.maxLength,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled ? null : theme.disabledColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            filled: true,
            fillColor: widget.fillColor ?? theme.colorScheme.surface,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  )
                : null,
            suffixIcon: _buildSuffix(),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.disabledColor),
            ),
            counterText: widget.showCounter ? null : '',
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffix != null) {
      return widget.suffix;
    }

    final List<Widget> suffixWidgets = [];

    // Add password visibility toggle
    if (widget.obscureText) {
      suffixWidgets.add(
        IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      );
    }

    // Add clear button
    if (widget.showClear && _controller.text.isNotEmpty) {
      if (suffixWidgets.isNotEmpty) {
        suffixWidgets.add(const SizedBox(width: 8));
      }
      suffixWidgets.add(
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: () {
            _controller.clear();
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
          },
        ),
      );
    }

    if (suffixWidgets.isEmpty) {
      return null;
    }

    if (suffixWidgets.length == 1) {
      return suffixWidgets.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: suffixWidgets,
    );
  }
}

/// Extension methods for common input types
extension CustomTextInputTypes on CustomTextInput {
  /// Creates an email input field
  static CustomTextInput email({
    String? label = 'Email',
    String? hint = 'Enter your email',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    bool showClear = true,
  }) {
    return CustomTextInput(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator ?? _emailValidator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
      enabled: enabled,
      showClear: showClear,
    );
  }

  /// Creates a password input field
  static CustomTextInput password({
    String? label = 'Password',
    String? hint = 'Enter your password',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) {
    return CustomTextInput(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator,
      obscureText: true,
      textInputAction: TextInputAction.done,
      prefixIcon: Icons.lock_outline,
      enabled: enabled,
    );
  }

  /// Creates a phone number input field
  static CustomTextInput phone({
    String? label = 'Phone',
    String? hint = 'Enter your phone number',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    bool showClear = true,
  }) {
    return CustomTextInput(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.phone_outlined,
      enabled: enabled,
      showClear: showClear,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  /// Creates a search input field
  static CustomTextInput search({
    String? hint = 'Search',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    bool enabled = true,
    bool readOnly = false,
    bool showClear = true,
  }) {
    return CustomTextInput(
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onTap: onTap,
      prefixIcon: Icons.search,
      enabled: enabled,
      readOnly: readOnly,
      showClear: showClear,
    );
  }
}

/// Default email validator
String? _emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}
