part of 'payment_card_cubit.dart';

sealed class PaymentCardState {}

final class PaymentCardInitial extends PaymentCardState {}

final class AddPaymentCardLoading extends PaymentCardState {}

final class AddPaymentCardSuccess extends PaymentCardState {}

final class AddPaymentCardFailed extends PaymentCardState {
  final String message;

  AddPaymentCardFailed({required this.message});
}

final class FetchingPaymentCards extends PaymentCardState {}

final class FetchingPaymentCardsSuccess extends PaymentCardState {
  final List<PaymentCardModel> cards;

  FetchingPaymentCardsSuccess({required this.cards});
}

final class FetchingPaymentCardsFailed extends PaymentCardState {
  final String message;

  FetchingPaymentCardsFailed({required this.message});
}

final class PaymentCardChosen extends PaymentCardState {
  final PaymentCardModel chosenCard;

  PaymentCardChosen({required this.chosenCard});
}

final class ConfirmingPaymentCards extends PaymentCardState {}

final class ConfirmingPaymentCardsSuccess extends PaymentCardState {}

final class ConfirmingPaymentCardsFailed extends PaymentCardState {
  final String message;

  ConfirmingPaymentCardsFailed({required this.message});
}
