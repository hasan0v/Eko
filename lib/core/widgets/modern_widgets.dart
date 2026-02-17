import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';

/// Modern card widget with gradient, shadow, and animations
class ModernCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const ModernCard({
    Key? key,
    required this.child,
    this.gradient,
    this.color,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.boxShadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? (gradient == null ? Colors.white : null),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? AppShadows.cardShadow,
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
      ),
      child: Padding(padding: padding!, child: child),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: container,
      );
    }

    return container;
  }
}

/// Gradient icon container
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;
  final double padding;
  final double borderRadius;

  const GradientIcon({
    Key? key,
    required this.icon,
    this.size = 24,
    this.gradient = AppGradients.primaryGradient,
    this.padding = 12,
    this.borderRadius = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

/// Modern section header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1D1F),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Color(0xFF6C7278),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Modern stat indicator
class StatIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final String? unit;

  const StatIndicator({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.gradient = AppGradients.primaryGradient,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GradientIcon(icon: icon, gradient: gradient, size: 24, padding: 12),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (unit != null) ...[
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          unit!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradient = AppGradients.primaryGradient,
    this.icon,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? Colors.grey.shade300 : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed != null ? AppShadows.buttonShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

/// Modern progress indicator
class ModernProgressIndicator extends StatelessWidget {
  final double value;
  final String label;
  final Gradient gradient;
  final Color backgroundColor;

  const ModernProgressIndicator({
    Key? key,
    required this.value,
    required this.label,
    this.gradient = AppGradients.primaryGradient,
    this.backgroundColor = const Color(0xFFE8ECF0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                Container(width: double.infinity, color: backgroundColor),
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(gradient: gradient),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
