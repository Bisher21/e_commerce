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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(70),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.grey2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () => cubit.removeCartItem(cartItem.id),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${cartItem.size.name}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
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
                                    fontWeight: FontWeight.bold,
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
                                  fontWeight: FontWeight.bold,
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
