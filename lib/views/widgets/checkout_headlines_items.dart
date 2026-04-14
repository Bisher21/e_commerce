import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CheckoutHeadlinesItems extends StatelessWidget {
  final String title;
  final int? productsAmount;
  final VoidCallback? onTap;

  const CheckoutHeadlinesItems({
    super.key,
    required this.title,
    this.productsAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (productsAmount != null) ...[
                const SizedBox(width: 8),
                Text(
                  "($productsAmount)",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                ),
              ],
            ],
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              child: const Text(
                "Edit",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
