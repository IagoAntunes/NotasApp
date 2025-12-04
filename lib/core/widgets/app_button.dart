// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:notes_app/core/styles/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.borderRadius = 8,
  }) : variant = _ButtonVariant.primary;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  final _ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !isLoading && onPressed != null;

    final background = switch (variant) {
      _ButtonVariant.primary => AppColors.primary,
    };

    final textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: Colors.white,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(label, style: textStyle),
      ),
    );
  }
}

enum _ButtonVariant {
  primary
}
