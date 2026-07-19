import 'package:flutter/material.dart';

/// AppSizes defines standard layout spacing, margins, border radii, and sizes.
abstract class AppSizes {
  // Padding & Margins
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  // Border Radii
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Chart & Graphic Heights
  static const double chartHeightSmall = 150.0;
  static const double chartHeightMedium = 220.0;
  static const double chartHeightLarge = 300.0;

  // Reusable Gap widgets for layouts
  static const SizedBox gapW4 = SizedBox(width: p4);
  static const SizedBox gapW8 = SizedBox(width: p8);
  static const SizedBox gapW12 = SizedBox(width: p12);
  static const SizedBox gapW16 = SizedBox(width: p16);
  static const SizedBox gapW20 = SizedBox(width: p20);
  static const SizedBox gapW24 = SizedBox(width: p24);
  static const SizedBox gapW32 = SizedBox(width: p32);

  static const SizedBox gapH4 = SizedBox(height: p4);
  static const SizedBox gapH8 = SizedBox(height: p8);
  static const SizedBox gapH12 = SizedBox(height: p12);
  static const SizedBox gapH16 = SizedBox(height: p16);
  static const SizedBox gapH20 = SizedBox(height: p20);
  static const SizedBox gapH24 = SizedBox(height: p24);
  static const SizedBox gapH32 = SizedBox(height: p32);
  static const SizedBox gapH40 = SizedBox(height: p40);
  static const SizedBox gapH48 = SizedBox(height: p48);
}
