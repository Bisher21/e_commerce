import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(cartItem: state.cartItems[index]);
                  },
                ),
              ),
              BlocBuilder<CartCubit, CartState>(
                bloc: BlocProvider.of<CartCubit>(context),
                buildWhen: (previous, current) =>
                    current is SubtotalUpdated,
                builder: (context, subtotalState) {
                  if (subtotalState is SubtotalUpdated) {
                    return CartSummaryWidget(subtotal:subtotalState.subTotal);
                  }else{
                   return  CartSummaryWidget(subtotal:state.subTotal);
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
