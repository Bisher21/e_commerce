import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';


import '../../utils/app_colors.dart';

class CounterWidgetDetailsPage extends StatelessWidget {
  final int value;
  final String productId;
  final ProductDetailsCubit cubit;

  const CounterWidgetDetailsPage( {super.key, required this.value, required this.productId, required this.cubit});

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
                  onPressed:()=>cubit.decrementCounter(productId),
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
                  onPressed:()=>cubit.incrementCounter(productId),
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
