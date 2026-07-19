import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';

enum AppButtonType { primary, secondary, outlined, text }

/// A highly polished, animated reusable button for the InvestTrack application.
/// Integrates custom scaling physics on tap to provide premium micro-animations.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed,
    required this.text,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    super.key,
  });

  const AppButton.secondary({
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    super.key,
  }) : type = AppButtonType.secondary;

  const AppButton.outlined({
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    super.key,
  }) : type = AppButtonType.outlined;

  const AppButton.text({
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : type = AppButtonType.text;

  final VoidCallback? onPressed;
  final String text;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04, // Shrinks by max 4%
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _animationController.reverse();
      widget.onPressed?.call();
    }
  }

  void _onTapCancel() {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final isText = widget.type == AppButtonType.text;

    Color? backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    if (widget.isDisabled) {
      backgroundColor = isText ? Colors.transparent : theme.colorScheme.surfaceContainerHighest;
      foregroundColor = theme.disabledColor;
    } else {
      switch (widget.type) {
        case AppButtonType.primary:
          backgroundColor = theme.colorScheme.primary;
          foregroundColor = theme.colorScheme.onPrimary;
          break;
        case AppButtonType.secondary:
          backgroundColor = theme.colorScheme.secondary;
          foregroundColor = theme.colorScheme.onSecondary;
          break;
        case AppButtonType.outlined:
          backgroundColor = Colors.transparent;
          foregroundColor = theme.colorScheme.primary;
          borderSide = BorderSide(color: theme.colorScheme.primary, width: 1.5);
          break;
        case AppButtonType.text:
          backgroundColor = Colors.transparent;
          foregroundColor = theme.colorScheme.primary;
          break;
      }
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          AppSizes.gapW8,
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: foregroundColor),
          AppSizes.gapW8,
        ],
        Text(
          widget.text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );

    if (widget.fullWidth) {
      content = SizedBox(
        width: double.infinity,
        child: content,
      );
    }

    final buttonStyle = OutlinedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: borderSide,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p24,
        vertical: AppSizes.p16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: OutlinedButton(
          onPressed: null, // Gesture handled by parent detector for scale physics
          style: buttonStyle,
          child: content,
        ),
      ),
    );
  }
}
