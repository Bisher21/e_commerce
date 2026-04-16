import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final bool? isLoading;

  CustomElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 32,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.isLoading = false,
  }) {
    assert(text != null || isLoading == true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPrimary =
        backgroundColor == AppColors.primary ||
        backgroundColor == Colors.deepPurple;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: isPrimary && isLoading != true
              ? const LinearGradient(
                  colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary ? null : backgroundColor,
          boxShadow: isPrimary && isLoading != true
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? Colors.transparent : backgroundColor,
            shadowColor: Colors.transparent,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
          ),
          onPressed: isLoading == true ? null : onPressed,
          child: isLoading == true
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: isPrimary ? Colors.white : AppColors.primary,
                  ),
                )
              : Text(
                  text!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}
