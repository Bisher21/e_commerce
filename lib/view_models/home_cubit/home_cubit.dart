import 'package:e_commerce/models/home_carousel_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/favorite_services.dart';
import 'package:e_commerce/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  HomeServices homeServices = HomeServicesImpl();
  FavoriteServices favoriteServices = FavoriteServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();
  Future<void> fetchHomePageData() async {
    emit(HomeLoading());
    try {
      final products = await homeServices.fetchProducts();
      final homeCarousalItems = await homeServices.fetchAnnouncements();
      final favorites = await favoriteServices.fetchFavorites(
        authServices.currentUser()!.uid,
      );
      final finalProducts = products.map((product) {
        final isFavorite = favorites.any((element) => element.id == product.id);
        return product.copyWith(isFavorite: isFavorite);
      }).toList();
      emit(
        HomeLoaded(products: finalProducts, carouselItems: homeCarousalItems),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel productItem) async {
    emit(SetFavoriteLoading(productId: productItem.id));
    try {
      final favorites = await favoriteServices.fetchFavorites(
        authServices.currentUser()!.uid,
      );
      final isFavorite = favorites.any(
        (element) => element.id == productItem.id,
      );
      if (isFavorite) {
        await favoriteServices.removeFromFavorites(
          authServices.currentUser()!.uid,
          productItem.id,
        );
      } else {
        await favoriteServices.addToFavorites(
          authServices.currentUser()!.uid,
          productItem,
        );
      }
      emit(SetFavoriteDone(isFavorite: !isFavorite, productId: productItem.id));
    } catch (e) {
      emit(SetFavoriteError(message: e.toString(), productId: productItem.id));
    }
  }
}
