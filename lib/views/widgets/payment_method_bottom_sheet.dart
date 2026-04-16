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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      height: MediaQuery.of(context).size.height * 0.62,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Drag Handle ────────────────────────────────────────────
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment Methods",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: paymentsCubit,
                        child: const AddNewCardPage(),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        "Add New",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final paymentCard = state.cards[index];
                      return BlocBuilder<PaymentCardCubit, PaymentCardState>(
                        buildWhen: (previous, current) =>
                            current is PaymentCardChosen,
                        bloc: paymentsCubit,
                        builder: (context, state) {
                          if (state is PaymentCardChosen) {
                            final chosenCard = state.chosenCard;
                            final isSelected = chosenCard.id == paymentCard.id;
                            return InkWell(
                              onTap: () {
                                paymentsCubit.changePaymentMethod(
                                  paymentCard.id,
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 36,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: AppColors.grey1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator.adaptive(),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.credit_card),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Mastercard',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              '**** **** **** ${paymentCard.cardNumber.substring(paymentCard.cardNumber.length - 4)}',
                                              style: const TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        )
                                      else
                                        Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          color: Colors.grey.shade300,
                                          size: 20,
                                        ),
                                    ],
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
