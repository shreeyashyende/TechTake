import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// A glassmorphism container with backdrop blur effect.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? blurAmount;
  final bool showBorder;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.blurAmount,
    this.showBorder = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppDimensions.cardRadius,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount ?? AppDimensions.blurRadius,
          sigmaY: blurAmount ?? AppDimensions.blurRadius,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassLayer,
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.cardRadius,
            ),
            border: showBorder
                ? Border.all(
                    color: borderColor ?? AppColors.border,
                    width: AppDimensions.cardBorderWidth,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
