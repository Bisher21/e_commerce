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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

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

          if (!isCheckout) ...[
            _SummaryRow(label: "Subtotal", value: subtotal),
            const SizedBox(height: 10),
            _SummaryRow(label: "Shipping", value: shippingPrice),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(color: Colors.grey.shade200, thickness: 1),
            ),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCheckout ? "Total Amount" : "Total",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: total.toStringAsFixed(2),
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
