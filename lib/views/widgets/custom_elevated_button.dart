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
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: isLoading == true
            ? const CircularProgressIndicator.adaptive()
            : Text(
                text!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
