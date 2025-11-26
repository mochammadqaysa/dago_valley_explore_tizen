import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:flutter/material.dart';

class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glassColor;
  final double borderRadius;

  const LiquidGlassCard({
    Key? key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.glassColor,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = LiquidGlassContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      glassColor: glassColor,
      borderRadius: borderRadius,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}
