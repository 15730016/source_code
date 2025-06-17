import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;
  final String? message;
  final bool isOverlay;
  final Color? backgroundColor;

  const LoadingIndicator({
    Key? key,
    this.color,
    this.size = 36.0,
    this.strokeWidth = 4.0,
    this.message,
    this.isOverlay = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.primaryColor;

    Widget loader = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            strokeWidth: strokeWidth,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isOverlay ? Colors.white : theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: backgroundColor ?? Colors.black54,
        child: Center(child: loader),
      );
    }

    return Center(child: loader);
  }

  /// Shows a loading overlay on top of the current screen
  static Future<T> showOverlay<T>({
    required BuildContext context,
    required Future<T> Function() asyncFunction,
    String? message,
    bool barrierDismissible = false,
  }) async {
    final overlay = OverlayEntry(
      builder: (context) => LoadingIndicator(
        isOverlay: true,
        message: message,
      ),
    );

    Overlay.of(context).insert(overlay);

    try {
      final result = await asyncFunction();
      overlay.remove();
      return result;
    } catch (e) {
      overlay.remove();
      rethrow;
    }
  }

  /// Creates a shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  /// Creates a skeleton loading placeholder
  static Widget skeleton({
    double? width,
    double? height,
    double borderRadius = 8,
    EdgeInsets? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Creates a list skeleton loading placeholder
  static Widget listSkeleton({
    int itemCount = 5,
    double itemHeight = 80,
    EdgeInsets padding = const EdgeInsets.all(16),
    EdgeInsets itemMargin = const EdgeInsets.only(bottom: 16),
  }) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => shimmer(
        child: skeleton(
          height: itemHeight,
          margin: itemMargin,
        ),
      ),
    );
  }

  /// Creates a grid skeleton loading placeholder
  static Widget gridSkeleton({
    int crossAxisCount = 2,
    int itemCount = 4,
    double aspectRatio = 1,
    EdgeInsets padding = const EdgeInsets.all(16),
    double spacing = 16,
  }) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => shimmer(
        child: skeleton(),
      ),
    );
  }
}

/// A widget that creates a shimmer loading effect
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              widget.baseColor ?? Colors.grey[300]!,
              widget.highlightColor ?? Colors.grey[100]!,
              widget.baseColor ?? Colors.grey[300]!,
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment(_animation.value - 1, _animation.value),
            end: Alignment(_animation.value, _animation.value + 1),
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
