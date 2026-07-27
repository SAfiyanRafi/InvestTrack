import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// A premium, animated loader. Supports both inline states and fullscreen modal blur screens.
class AppLoader extends StatelessWidget {
  const AppLoader({this.message, this.isFullscreen = false, super.key});

  /// Optional text to show below the progress indicator
  final String? message;

  /// If true, displays a fullscreen blurred overlay.
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget loaderContent = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.p20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceCard.withValues(alpha: 0.9)
                  : AppColors.lightSurfaceCard.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppSizes.r20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            AppSizes.gapH16,
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );

    if (isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Backdrop Blur Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color:
                      (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground)
                          .withValues(alpha: 0.6),
                ),
              ),
            ),
            loaderContent,
          ],
        ),
      );
    }

    return loaderContent;
  }
}
