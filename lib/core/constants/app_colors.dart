import 'package:flutter/material.dart';

/// AppColors defines the color palette used throughout InvestTrack.
/// Follows Material Design 3 guidelines with a custom premium finish.
abstract class AppColors {
  // Common Colors
  static const Color primary = Color(0xFF6366F1); // Indigo Accent
  static const Color secondary = Color(0xFF0D9488); // Teal Accent
  static const Color success = Color(0xFF10B981); // Emerald (Profit/ROI)
  static const Color warning = Color(0xFFF59E0B); // Amber (Pending/Loan)
  static const Color error = Color(0xFFEF4444); // Rose (Loss/Expense)

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF090D16); // Deep Obsidian
  static const Color darkSurface = Color(0xFF111827); // Rich Slate Dark
  static const Color darkSurfaceCard = Color(0xFF1F2937); // Lighter Grey/Slate
  static const Color darkBorder = Color(0xFF374151); // Divider and border
  static const Color darkTextPrimary = Color(0xFFF9FAFB); // Cool White
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // Muted Grey
  static const Color darkTextMuted = Color(0xFF6B7280); // Darker Muted Grey

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Clean Slate Light
  static const Color lightSurface = Color(0xFFFFFFFF); // Crisp White
  static const Color lightSurfaceCard = Color(0xFFF1F5F9); // Light Grey/Slate
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Border
  static const Color lightTextPrimary = Color(0xFF0F172A); // Dark Slate Text
  static const Color lightTextSecondary = Color(0xFF475569); // Muted Slate Text
  static const Color lightTextMuted = Color(0xFF94A3B8); // Muted Grey Text

  // Utility colors
  static const Color shadowColor = Color(0x0A000000);
}
