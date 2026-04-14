import '../models/product_item_model.dart';
import '../utils/api_paths.dart';
import 'firestore_services.dart';

abstract class FavoriteServices {
  Future<void> addToFavorites(String uId, ProductItemModel product);
  Future<void> removeFromFavorites(String uId, String productId);
  Future<List<ProductItemModel>> fetchFavorites(String uId);
}

class FavoriteServicesImpl implements FavoriteServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<void> addToFavorites(String uId, ProductItemModel product) async {
    await firestoreServices.setData(
      path: ApiPaths.favoriteProduct(uId, product.id),
      data: product.toMap(),
    );
  }

  @override
  Future<void> removeFromFavorites(String uId, String productId) async {
    await firestoreServices.deleteData(
      path: ApiPaths.favoriteProduct(uId, productId),
    );
  }

  @override
  Future<List<ProductItemModel>> fetchFavorites(String uId) async {
    return await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.favorites(uId),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
  }
}
