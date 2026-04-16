import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/add_to_cart_model.dart';
import '../../view_models/cart_cubit/cart_cubit.dart';
import 'counter_widget_cart_page.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    final product = cartItem.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 88,
                width: 88,
                color: AppColors.grey2,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 14),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: -0.1,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      BlocBuilder<CartCubit, CartState>(
                        buildWhen: (previous, current) =>
                            (current is RemovingCartItem &&
                                current.cartItemId == cartItem.id) ||
                            (current is CartItemRemoved &&
                                current.cartItemId == cartItem.id) ||
                            (current is RemovingCartItemError &&
                                previous is RemovingCartItem &&
                                previous.cartItemId == cartItem.id),
                        builder: (context, state) {
                          if (state is RemovingCartItem &&
                              state.cartItemId == cartItem.id) {
                            return const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => cubit.removeCartItem(cartItem.id),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Size: ${cartItem.size.name}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CartCubit, CartState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is QuantityCounterLoaded &&
                        current.cartItemId == cartItem.id,
                    builder: (context, state) {
                      if (state is QuantityCounterLoaded &&
                          state.cartItemId == cartItem.id) {
                        final updatedCartItem = cartItem.copyWith(
                          quantity: state.value,
                        );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(state.value * cartItem.product.price).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            CounterWidgetCartPage(
                              value: state.value,
                              cartItem: updatedCartItem,
                              cubit: cubit,
                            ),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          CounterWidgetCartPage(
                            value: cartItem.quantity,
                            cartItem: cartItem,
                            cubit: cubit,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
