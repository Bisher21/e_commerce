import 'package:e_commerce/models/payment_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_services.dart';
import '../../services/checkout_services.dart';

part 'payment_card_state.dart';

class PaymentCardCubit extends Cubit<PaymentCardState> {
  PaymentCardCubit() : super(PaymentCardInitial());
  String? selectedId;
  final checkoutServices = CheckoutServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();

  Future<void> addPaymentCard(
    String cardNum,
    String holderName,
    String cvv,
    String expiryDate,
  ) async {
    emit(AddPaymentCardLoading());

    final paymentCardItem = PaymentCardModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNum,
      cardHolderName: holderName,
      expiryDate: cvv,
      cvv: expiryDate,
    );
    try {
      await checkoutServices.setCard(
        authServices.currentUser()!.uid,
        paymentCardItem,
      );
      emit(AddPaymentCardSuccess());
    } catch (e) {
      emit(AddPaymentCardFailed(message: e.toString()));
    }
  }

  Future<void> fetchPaymentCards() async {
    emit(FetchingPaymentCards());
    try {
      final cards = await checkoutServices.fetchPaymentCards(
        authServices.currentUser()!.uid,
      );
      emit(FetchingPaymentCardsSuccess(cards: cards));
      if (cards.isNotEmpty) {
        final card = cards.firstWhere(
          (element) => element.isSelected,
          orElse: () => cards.first,
        );
        selectedId = card.id;
        emit(PaymentCardChosen(chosenCard: card));
      }
    } catch (e) {
      emit(FetchingPaymentCardsFailed(message: e.toString()));
    }
  }

  Future<void> changePaymentMethod(String id) async {
    selectedId = id;
    try {
      final tempChosenCard = await checkoutServices.fetchPaymentCard(
        authServices.currentUser()!.uid,
        selectedId!,
      );

      emit(PaymentCardChosen(chosenCard: tempChosenCard));
    } catch (e) {
      emit(FetchingPaymentCardsFailed(message: e.toString()));
    }
  }

  Future<void> confirmPayment() async {
    emit(ConfirmingPaymentCards());
    try {
      // ✅ only deselect previous card if one exists
      final previousCards = await checkoutServices.fetchPaymentCards(
        authServices.currentUser()!.uid,
        true,
      );
      if (previousCards.isNotEmpty) {
        final previousChosenCard = previousCards.first.copyWith(
          isSelected: false,
        );
        await checkoutServices.setCard(
          authServices.currentUser()!.uid,
          previousChosenCard,
        );
      }

      var chosenCard = await checkoutServices.fetchPaymentCard(
        authServices.currentUser()!.uid,
        selectedId!,
      );
      chosenCard = chosenCard.copyWith(isSelected: true);
      await checkoutServices.setCard(
        authServices.currentUser()!.uid,
        chosenCard,
      );

      emit(ConfirmingPaymentCardsSuccess());
    } catch (e) {
      emit(ConfirmingPaymentCardsFailed(message: e.toString()));
    }
  }
}
