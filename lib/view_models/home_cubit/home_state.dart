part of 'home_cubit.dart';


sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState{}

final class HomeLoaded extends HomeState{

  final List<ProductItemModel> products;
  final List<HomeCarouselItem> carouselItems;


  HomeLoaded({required this.products, required this.carouselItems});
}
final class HomeError extends HomeState{
  final String message;

  HomeError({required this.message});

}

final class SetFavoriteLoading extends HomeState{
  final String productId;

  SetFavoriteLoading({required this.productId});
}

final class SetFavoriteDone extends HomeState{
  final bool isFavorite;
  final String productId;

  SetFavoriteDone({required this.isFavorite, required this.productId});
}

final class SetFavoriteError extends HomeState{
  final String message;
  final String productId;

  SetFavoriteError({required this.message, required this.productId});
}