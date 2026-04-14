import 'package:e_commerce/models/add_to_cart_model.dart';
import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';


import '../../utils/app_colors.dart';

class CounterWidgetCartPage extends StatelessWidget {
  final int value;
  final  AddToCartModel cartItem;
  final CartCubit cubit;

  const CounterWidgetCartPage( {super.key, required this.value, required this.cartItem, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: const BorderRadius.all(Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed:()=>cubit.decrementCounter(cartItem),
                  icon: const Icon(Icons.remove, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              value.toString(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.black),
            ),
            const SizedBox(width: 5),
            SizedBox(
              height: 30,
              width: 30,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed:()=>cubit.incrementCounter(cartItem),
                  icon: const Icon(Icons.add, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
