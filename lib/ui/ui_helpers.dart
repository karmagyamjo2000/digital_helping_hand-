import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double kSpacing = 16.0;
const double kCardRadius = 24.0;
const double kButtonRadius = 16.0;
const double kNavBarHeight = 70.0;
const Duration kAnimDuration = Duration(milliseconds: 360);
const Color kBackground = Color(0xFFF7F8FA);

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF6CC1FF);
  static const Color primaryDark = Color(0xFF4F8EF7);
  static const Color accent = Color(0xFFF9A825);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDEE2E6);
}

class AppTypography {
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey[700],
  );
  static TextStyle body = GoogleFonts.poppins(
    fontSize: 15,
    color: Colors.black87,
  );
  static TextStyle label = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.grey[600],
  );
}

class RoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kAnimDuration,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GlassBottomNav extends StatelessWidget {
  final Widget child;
  const GlassBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: kNavBarHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  const GradientButton({
    super.key,
    required this.onPressed,
    this.label,
    this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 48),
          child:
              child ??
              Text(
                label!,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.25)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
            ),
        ],
      ),
    );
  }
}

Widget appBarTitle(String title) {
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.handshake, color: Colors.white, size: 24),
      ),
      const SizedBox(width: 12),
      Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}
