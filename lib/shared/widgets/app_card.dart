import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// A premium, customizable card container that supports subtle tap physics.
class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.p16),
    this.margin,
    this.borderRadius = AppSizes.r16,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.hasGradient = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasGradient;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(covariant AppCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onTap != widget.onTap) {
      _syncAnimationState();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _syncAnimationState() {
    if (widget.onTap == null) {
      _animationController?.dispose();
      _animationController = null;
      _scaleAnimation = const AlwaysStoppedAnimation<double>(1.0);
      return;
    }

    _animationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.02, // 2% compression
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController?.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController?.reverse();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _animationController?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseBgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    
    final finalBorderColor = widget.borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    final boxDecoration = BoxDecoration(
      color: widget.hasGradient ? null : baseBgColor,
      gradient: widget.hasGradient
          ? LinearGradient(
              colors: isDark
                  ? [
                      AppColors.darkSurface,
                      AppColors.darkSurfaceCard.withValues(alpha: 0.8),
                    ]
                  : [
                      AppColors.lightSurface,
                      AppColors.lightSurfaceCard.withValues(alpha: 0.8),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(color: finalBorderColor, width: 1),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 12,
          offset: Offset(0, 4),
        )
      ],
    );

    Widget cardContent = Container(
      padding: widget.padding,
      decoration: boxDecoration,
      child: widget.child,
    );

    if (widget.margin != null) {
      cardContent = Padding(
        padding: widget.margin!,
        child: cardContent,
      );
    }

    if (widget.onTap == null) {
      return cardContent;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: cardContent,
      ),
    );
  }
}
