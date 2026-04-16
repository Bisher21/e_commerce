import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CounterWidgetDetailsPage extends StatelessWidget {
  final int value;
  final String productId;
  final ProductDetailsCubit cubit;

  const CounterWidgetDetailsPage({
    super.key,
    required this.value,
    required this.productId,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: const BorderRadius.all(Radius.circular(36)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(
            icon: Icons.remove_rounded,
            onPressed: () => cubit.decrementCounter(productId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                value.toString(),
                key: ValueKey(value),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _CounterButton(
            icon: Icons.add_rounded,
            onPressed: () => cubit.incrementCounter(productId),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CounterButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icon, size: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
