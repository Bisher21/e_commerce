import 'package:e_commerce/models/add_to_cart_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/api_paths.dart';

import 'firestore_services.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String id);
  Future<void> addToCart(String userId, AddToCartModel cartItem);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<ProductItemModel> fetchProductDetails(String id) async {
    final selectedProduct = await firestoreServices
        .getDocument<ProductItemModel>(
          path: ApiPaths.product(id),
          builder: (data, documentID) => ProductItemModel.fromMap(data),
        );
    return selectedProduct;
  }

  @override
  Future<void> addToCart(String userId, AddToCartModel cartItem) async =>
      await firestoreServices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );
}
