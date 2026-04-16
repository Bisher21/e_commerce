import 'package:e_commerce/models/address_model.dart';
import 'package:e_commerce/models/payment_card_model.dart';
import 'package:e_commerce/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/add_to_cart_model.dart';
import '../../services/auth_services.dart';
import '../../services/cart_services.dart';
import '../../services/checkout_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final locationServices = LocationServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();
  final CartServices cartServices = CartServicesImpl();

  Future<void> getCheckoutData() async {
    emit(CheckoutLoading());
    try {
      final String uid = authServices.currentUser()!.uid;

      // 1. Fetch Cart Items
      final cartItems = await cartServices.fetchCartItems(uid);
      final subtotal = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
      final numOfProducts = cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );


      final selectedCards = await checkoutServices.fetchPaymentCards(uid, true);
      PaymentCardModel? card;
      
      if (selectedCards.isNotEmpty) {
        card = selectedCards.first;
      } else {

        final allCards = await checkoutServices.fetchPaymentCards(uid, false);
        if (allCards.isNotEmpty) {
          card = allCards.first;
        }
      }


      final selectedAddresses = await locationServices.fetchLocations(uid, true);
      AddressModel? chosenAddress;

      if (selectedAddresses.isNotEmpty) {
        chosenAddress = selectedAddresses.first;
      } else {

        final allAddresses = await locationServices.fetchLocations(uid, false);
        if (allAddresses.isNotEmpty) {
          chosenAddress = allAddresses.first;
        }
      }

      emit(
        CheckoutLoaded(
          cartItems: cartItems,
          totalPrice: subtotal,
          numOfProducts: numOfProducts,
          chosenCard: card,
          chosenAddress: chosenAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }
}
