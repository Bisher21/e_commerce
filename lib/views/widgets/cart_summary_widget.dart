import 'package:e_commerce/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';

class CartSummaryWidget extends StatelessWidget {
  final double subtotal;
  final bool isCheckout;
  final String buttonText;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    this.isCheckout = false,
    this.buttonText = "Checkout",
  });

  @override
  Widget build(BuildContext context) {
    const double shippingPrice = 10.0;
    final double total = subtotal + shippingPrice;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(14),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCheckout) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal", style: TextStyle(color: AppColors.grey)),
                Text(
                  "\$${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Shipping", style: TextStyle(color: AppColors.grey)),
                Text(
                  "\$${shippingPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCheckout ? "Total Amount" : "Total",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            text: buttonText,
            onPressed: () {
              if (!isCheckout) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(AppRoutes.checkoutRoute);
              } else {
                // Proceed to buy logic
              }
            },
          ),
        ],
      ),
    );
  }
}
