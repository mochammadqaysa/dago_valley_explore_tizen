import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glassColor;
  final Color? glassAccentColor;
  final double borderRadius;
  final double blurIntensity;
  final bool showBorder;
  final bool showShadow;

  const LiquidGlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.glassColor,
    this.glassAccentColor,
    this.borderRadius = 8,
    this.blurIntensity = 0.1,
    this.showBorder = true,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultGlassColor = glassColor ?? Colors.grey.withOpacity(0.1);
    final defaultGlassAccentColor =
        glassAccentColor ?? Colors.white.withOpacity(0.1);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  defaultGlassColor.withOpacity(0.3),
                  defaultGlassAccentColor.withOpacity(0.2),
                  defaultGlassColor.withOpacity(0.3),
                  defaultGlassAccentColor.withOpacity(0.2),
                  defaultGlassColor.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: showBorder
                  ? Border.all(color: Colors.white.withOpacity(0.2), width: 1.5)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
