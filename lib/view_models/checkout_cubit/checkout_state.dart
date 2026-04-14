part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<AddToCartModel> cartItems;
  final double totalPrice;
  final int numOfProducts;
  final PaymentCardModel? chosenCard;
  final AddressModel? chosenAddress;

  CheckoutLoaded({required this.cartItems, required this.totalPrice, required this.numOfProducts,  this.chosenCard, this.chosenAddress});
}

final class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}
