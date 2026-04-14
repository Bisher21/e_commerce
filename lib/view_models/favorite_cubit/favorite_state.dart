part of 'favorite_cubit.dart';

sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FetchingFavorites extends FavoriteState {}

final class FetchingFavoritesDone extends FavoriteState {
  final List<ProductItemModel> favorites;

  FetchingFavoritesDone({required this.favorites});
}

final class FetchingFavoritesError extends FavoriteState {
  final String message;
  FetchingFavoritesError({required this.message});
}

final class RemovingFavorite extends FavoriteState {
  final String productId;

  RemovingFavorite({required this.productId});
}

final class FavoriteRemoved extends FavoriteState {
  final String productId;

  FavoriteRemoved({required this.productId});
}

final class RemovingFavoriteError extends FavoriteState {
  final String message;

  RemovingFavoriteError({required this.message});
}
