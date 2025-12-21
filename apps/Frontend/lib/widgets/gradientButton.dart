import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 48,
    this.borderRadius = 26,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    // default gradient matched to example (blue -> purple)
    this.gradient = const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  });

  @override
  Widget build(BuildContext context) {
    // Use Material -> Ink -> InkWell to get proper ripple on top of gradient
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Container(
            height: height,
            padding: padding,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
