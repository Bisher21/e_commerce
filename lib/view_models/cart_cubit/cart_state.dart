part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<AddToCartModel> cartItems;
  final double subTotal;

  CartLoaded({required this.cartItems, required this.subTotal});
}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});
}

final class QuantityCounterLoaded extends CartState {
  final int value;
  final String cartItemId;

  QuantityCounterLoaded({required this.value, required this.cartItemId});
}
final class QuantityCounterLoadedError extends CartState {
  final String message;

  QuantityCounterLoadedError({required this.message});

}

final class SubtotalUpdated extends CartState {
  final double subTotal;

  SubtotalUpdated({required this.subTotal});
}

final class RemovingCartItem extends CartState {
  final String cartItemId;

  RemovingCartItem({required this.cartItemId});
}

final class CartItemRemoved extends CartState {
  final String cartItemId;

  CartItemRemoved({required this.cartItemId});
}

final class RemovingCartItemError extends CartState {
  final String message;

  RemovingCartItemError({required this.message});
}
