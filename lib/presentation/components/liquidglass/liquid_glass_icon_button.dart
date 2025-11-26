import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_button.dart';
import 'package:flutter/material.dart';

class LiquidGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? glassColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final bool enabled;

  const LiquidGlassIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.glassColor,
    this.iconColor,
    this.size = 56,
    this.iconSize = 24,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassButton(
      width: size,
      height: size,
      glassColor: glassColor,
      onPressed: onPressed,
      enabled: enabled,
      child: Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
    );
  }
}
