import 'package:e_commerce/services/cart_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/add_to_cart_model.dart';
import '../../services/auth_services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartServices cartServices = CartServicesImpl();
  final AuthServices authServices = AuthServicesImpl();
  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final cartItems = await cartServices.fetchCartItems(
        authServices.currentUser()!.uid,
      );
      final subtotal = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
      emit(CartLoaded(cartItems: cartItems, subTotal: subtotal));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> incrementCounter(AddToCartModel cartItem) async {
    try {
      final newCartItem = cartItem.copyWith(quantity: cartItem.quantity + 1);
      await cartServices.setCounter(
        authServices.currentUser()!.uid,
        newCartItem,
      );
      emit(
        QuantityCounterLoaded(
          value: newCartItem.quantity,
          cartItemId: cartItem.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(
        authServices.currentUser()!.uid,
      );
      final subtotal = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
      emit(SubtotalUpdated(subTotal: subtotal));
    } catch (e) {
      emit(QuantityCounterLoadedError(message: e.toString()));
    }
  }

  Future<void> decrementCounter(AddToCartModel cartItem) async {
    if (cartItem.quantity <= 1) return;
    try {
      final newCartItem = cartItem.copyWith(quantity: cartItem.quantity - 1);
      await cartServices.setCounter(
        authServices.currentUser()!.uid,
        newCartItem,
      );
      emit(
        QuantityCounterLoaded(
          value: newCartItem.quantity,
          cartItemId: cartItem.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(
        authServices.currentUser()!.uid,
      );
      final subtotal = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
      emit(SubtotalUpdated(subTotal: subtotal));
    } catch (e) {
      emit(QuantityCounterLoadedError(message: e.toString()));
    }
  }

  // double get _subTotal => dummyCarts.fold<double>(
  //   0,
  //   (sum, item) => sum + (item.product.price * item.quantity),
  // );
  Future<void> removeCartItem(String cartItemId) async {
    emit(RemovingCartItem(cartItemId: cartItemId));
    try {
      await cartServices.removeFromCarts(
        authServices.currentUser()!.uid,
        cartItemId,
      );
      emit(CartItemRemoved(cartItemId: cartItemId));
      final cartItems = await cartServices.fetchCartItems(
        authServices.currentUser()!.uid,
      );
      final subtotal = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
      emit(CartLoaded(cartItems: cartItems, subTotal: subtotal));
      emit(SubtotalUpdated(subTotal: subtotal));
    } catch (e) {
      emit(RemovingCartItemError(message: e.toString()));
    }
  }
}
