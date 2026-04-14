import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/payment_card_model.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final PaymentCardModel paymentCard;
  final VoidCallback onTap;
  

  const PaymentMethodWidget({
    super.key,
    required this.paymentCard, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey2),
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
              imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.credit_card),
            ),
          ),
          title: const Text(
            'Mastercard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '**** **** **** ${paymentCard.cardNumber.substring(paymentCard.cardNumber.length - 4)}',
            style: const TextStyle(color: AppColors.grey),
          ),
          trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
        ),
      ),
    );
  }
}
