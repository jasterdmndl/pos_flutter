import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Impeccable typography helpers — single source for the whole app.
/// 
/// Rule: No `GoogleFonts.` outside `app_theme.dart`.
/// * Fraunces = display / brand headlines (`display*` / `headline*` / `titleLarge` / AppBar)
/// * Space Grotesk = everything else (titles, body, labels, buttons, inputs)
/// 
/// Use via `Theme.of(context).textTheme.*` or these semantic shortcuts
/// when you need a specific overline/caption/price style with the correct
/// ink/emerald color and letterSpacing.
abstract class AppTextStyles {
  // ── Brand display (Fraunces) ────────────────────────────────────────────
  static TextStyle displayBrand(BuildContext context, {Color? color, double? fontSize}) =>
      Theme.of(context).textTheme.displayLarge!.copyWith(color: color, fontSize: fontSize);

  static TextStyle headlineSection(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppTheme.ink);

  // ── Overlines / labels ──────────────────────────────────────────────────
  static TextStyle overline(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(color: color ?? AppTheme.ink.withValues(alpha: 0.4));

  static TextStyle overlineBold(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: color ?? AppTheme.ink.withValues(alpha: 0.5),
          );

  static TextStyle labelEmphasis(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(color: color);

  // ── Body / captions ─────────────────────────────────────────────────────
  static TextStyle body(BuildContext context, {Color? color, FontWeight? weight}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(color: color, fontWeight: weight);

  static TextStyle bodyBold(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800, color: AppTheme.ink);

  static TextStyle captionMuted(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(color: AppTheme.ink.withValues(alpha: 0.4));

  static TextStyle captionMono(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            fontFamily: Theme.of(context).textTheme.bodySmall!.fontFamily,
            letterSpacing: 0.8,
            color: AppTheme.ink.withValues(alpha: 0.6),
          );

  // ── Prices / metrics ────────────────────────────────────────────────────
  static TextStyle priceLarge(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color ?? AppTheme.ink,
          );

  static TextStyle priceEmphasis(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppTheme.emerald,
          );
}
