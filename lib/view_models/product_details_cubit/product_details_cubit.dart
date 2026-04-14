import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/add_to_cart_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/product_details_services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? sizeOfItem;
  int quantityOfItems = 1;
  final productDetailsServices = ProductDetailsServicesImpl();

  void getProductDetail(String id) async {
    emit(ProductDetailsLoading());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );
      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  void incrementCounter(String id) {
    quantityOfItems++;

    emit(QuantityCounterLoaded(value: quantityOfItems));
  }

  void decrementCounter(String id) {
    quantityOfItems = quantityOfItems > 1 ? quantityOfItems - 1 : 1;
    emit(QuantityCounterLoaded(value: quantityOfItems));
  }

  void selectSize(ProductSize size) {
    sizeOfItem = size;
    emit(SelectedSize(size: size));
  }

  void addToCart(String id) async {
    emit(ProductAddingToCart());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );
      final addToCartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        quantity: quantityOfItems,
        size: sizeOfItem!,
      );

      productDetailsServices.addToCart(
        AuthServicesImpl().currentUser()!.uid,
        addToCartItem,
      );
      emit(ProductAddedToCart(productId: id));
    } catch (e) {
      emit(ProductAddingToCartFailed(message: e.toString()));
    }
  }
}
