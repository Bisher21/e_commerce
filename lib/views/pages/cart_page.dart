import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_colors.dart';
import '../../view_models/cart_cubit/cart_cubit.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      bloc: BlocProvider.of<CartCubit>(context),
      buildWhen: (previous, current) =>
          current is CartLoaded ||
          current is CartLoading ||
          current is CartError,
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is CartLoaded) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Your cart is empty",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add items to get started",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(cartItem: state.cartItems[index]);
                  },
                ),
              ),
              BlocBuilder<CartCubit, CartState>(
                bloc: BlocProvider.of<CartCubit>(context),
                buildWhen: (previous, current) => current is SubtotalUpdated,
                builder: (context, subtotalState) {
                  if (subtotalState is SubtotalUpdated) {
                    return CartSummaryWidget(subtotal: subtotalState.subTotal);
                  } else {
                    return CartSummaryWidget(subtotal: state.subTotal);
                  }
                },
              ),
            ],
          );
        } else if (state is CartError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
