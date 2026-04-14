import 'package:e_commerce/models/add_to_cart_model.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/api_paths.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);

  Future<void> removeFromCarts(String uId, String cartItemId);
  Future<void> setCounter(String uId, AddToCartModel cartItem);
}

class CartServicesImpl implements CartServices {
  final fireStoreServices = FirestoreServices.instance;
  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) {
    final cartItems = fireStoreServices.getCollection(
      path: ApiPaths.carts(userId),
      builder: (data, documentId) => AddToCartModel.fromMap(data),
    );
    return cartItems;
  }

  @override
  Future<void> removeFromCarts(String uId, String cartItemId) async {
    await fireStoreServices.deleteData(
      path: ApiPaths.cartItem(uId, cartItemId),
    );
  }

  @override
  Future<void> setCounter(String uId, AddToCartModel cartItem) async {
    await fireStoreServices.setData(
      path: ApiPaths.cartItem(uId, cartItem.id),
      data: cartItem.toMap(),
    );
  }


}
