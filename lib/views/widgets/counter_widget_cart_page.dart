import 'package:e_commerce/models/add_to_cart_model.dart';
import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CounterWidgetCartPage extends StatelessWidget {
  final int value;
  final AddToCartModel cartItem;
  final CartCubit cubit;

  const CounterWidgetCartPage({
    super.key,
    required this.value,
    required this.cartItem,
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
            onPressed: () => cubit.decrementCounter(cartItem),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                value.toString(),
                key: ValueKey(value),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _CounterButton(
            icon: Icons.add_rounded,
            onPressed: () => cubit.incrementCounter(cartItem),
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
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
