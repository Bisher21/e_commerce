
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../services/favorite_services.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());
  final AuthServicesImpl authServices = AuthServicesImpl();
  final FavoriteServicesImpl favoriteServices = FavoriteServicesImpl();
  Future<void> getFavoriteProducts() async {
    emit(FetchingFavorites());
    try {
      final favorites = await favoriteServices.fetchFavorites(
          authServices.currentUser()!.uid);
      emit(FetchingFavoritesDone(favorites: favorites));
    }catch(e){
      emit(FetchingFavoritesError(message: e.toString()));
    }

  }

  Future<void> removeFavorite(String productid) async {
    emit(RemovingFavorite(productId: productid));
    try {
      await favoriteServices.removeFromFavorites(
          authServices.currentUser()!.uid, productid);
      emit(FavoriteRemoved(productId: productid));
      final favoriteProducts= await favoriteServices.fetchFavorites( authServices.currentUser()!.uid);
      emit(FetchingFavoritesDone(favorites: favoriteProducts));
    }catch(e){
      emit(RemovingFavoriteError(message: e.toString()));
    }
  }
}
