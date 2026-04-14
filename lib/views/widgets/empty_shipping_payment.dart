import 'package:e_commerce/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyShippingPayment extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const EmptyShippingPayment({
    super.key,
    required this.title, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey2.withAlpha(50),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.grey.withAlpha(50),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: AppColors.primary.withAlpha(150),
            ),
            const SizedBox(height: 8),
            Text(
              "Please add your $title",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
