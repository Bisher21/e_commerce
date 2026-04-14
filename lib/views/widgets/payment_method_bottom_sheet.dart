import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/views/widgets/custom_elevated_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_models/payment_card_cubit/payment_card_cubit.dart';
import '../pages/add_new_card_page.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentsCubit = BlocProvider.of<PaymentCardCubit>(context);
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment Methods",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: paymentsCubit,          // the same cubit the bottom sheet uses
                        child: const AddNewCardPage(),
                      ),
                    ),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<PaymentCardCubit, PaymentCardState>(
              bloc: paymentsCubit,
              buildWhen: (previous, current) =>
                  current is FetchingPaymentCards ||
                  current is FetchingPaymentCardsSuccess ||
                  current is FetchingPaymentCardsFailed,
              builder: (context, state) {
                if (state is FetchingPaymentCards) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is FetchingPaymentCardsSuccess) {
                  if (state.cards.isEmpty) {
                    return const Center(child: Text("No payment cards found"));
                  }
                  return ListView.separated(
                    itemCount: state.cards.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final paymentCard = state.cards[index];
                      return BlocBuilder<PaymentCardCubit, PaymentCardState>(
                        buildWhen: (previous, current) =>
                            current is PaymentCardChosen,
                        bloc: paymentsCubit,
                        builder: (context, state) {
                          if (state is PaymentCardChosen) {
                            final chosenCard = state.chosenCard;
                            return InkWell(
                              onTap: () {
                                paymentsCubit.changePaymentMethod(
                                  paymentCard.id,
                                );
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: chosenCard.id == paymentCard.id
                                        ? AppColors.primary
                                        : AppColors.grey2,
                                    width: chosenCard.id == paymentCard.id
                                        ? 2
                                        : 1,
                                  ),
                                ),

                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => const Center(
                                        child:
                                            CircularProgressIndicator.adaptive(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.credit_card),
                                    ),
                                  ),
                                  title: const Text(
                                    'Mastercard',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '**** **** **** ${paymentCard.cardNumber.substring(paymentCard.cardNumber.length - 4)}',
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  );
                } else if (state is FetchingPaymentCardsFailed) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),
          BlocConsumer<PaymentCardCubit, PaymentCardState>(
            bloc: paymentsCubit,
            buildWhen: (previous, current) =>
                current is ConfirmingPaymentCardsSuccess ||
                current is ConfirmingPaymentCards ||
                current is ConfirmingPaymentCardsFailed,
            listenWhen: (previous, current) =>
                current is ConfirmingPaymentCardsSuccess,
            listener: (context, state) {
              if (state is ConfirmingPaymentCardsSuccess) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is ConfirmingPaymentCards) {
                return CustomElevatedButton(isLoading: true);
              }
              return CustomElevatedButton(
                text: "Confirm Payment",
                onPressed: () {
                  paymentsCubit.confirmPayment();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
