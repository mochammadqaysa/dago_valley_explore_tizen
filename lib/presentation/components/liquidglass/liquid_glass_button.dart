import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidGlassButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final Color? glassColor;
  final Color? textColor;
  final Color? rippleColor;
  final IconData? icon;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool enabled;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool showShadow;

  const LiquidGlassButton({
    Key? key,
    this.text,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.width,
    this.height = 56,
    this.glassColor,
    this.textColor,
    this.rippleColor,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.borderRadius = 16,
    this.padding,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final glassColor = this.glassColor ?? Colors.grey.withValues(alpha: 0.1);
    final textColor = this.textColor ?? Colors.white;
    final rippleColor = this.rippleColor ?? Colors.grey.withOpacity(0.3);
    final isDisabled = !enabled || onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        width: width,
        height: height,
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
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    glassColor.withOpacity(0.3),
                    Colors.black.withOpacity(0.2),
                    glassColor.withOpacity(0.3),
                    Colors.black.withOpacity(0.2),
                    glassColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : onPressed,
                  onLongPress: isDisabled ? null : onLongPress,
                  splashColor: rippleColor,
                  highlightColor: rippleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    padding:
                        padding ?? const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        child ??
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (leadingIcon != null) ...[
                                leadingIcon!,
                                const SizedBox(width: 8),
                              ],
                              if (icon != null) ...[
                                Icon(icon, color: textColor, size: 20),
                                const SizedBox(width: 8),
                              ],
                              if (text != null)
                                Text(
                                  text!,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: fontSize,
                                    fontWeight: fontWeight,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              if (trailingIcon != null) ...[
                                const SizedBox(width: 8),
                                trailingIcon!,
                              ],
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
