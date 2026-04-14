part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductItemModel product;

  ProductDetailsLoaded({required this.product});
}

final class QuantityCounterLoaded extends ProductDetailsState {
  final int value;

  QuantityCounterLoaded({required this.value});
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError({required this.message});
}

final class SelectedSize extends ProductDetailsState {
  final ProductSize size;

  SelectedSize({required this.size});
}

final class ProductAddingToCart extends ProductDetailsState {}

final class ProductAddedToCart extends ProductDetailsState {
  final String productId;

  ProductAddedToCart({required this.productId});
}
final class ProductAddingToCartFailed extends ProductDetailsState{
  final String message;

  ProductAddingToCartFailed({required this.message});

}
