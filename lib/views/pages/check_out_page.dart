import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/address_model.dart';
import 'package:e_commerce/utils/app_colors.dart';

import 'package:e_commerce/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce/views/widgets/cart_summary_widget.dart';
import 'package:e_commerce/views/widgets/empty_shipping_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment_card_model.dart';
import '../../utils/app_routes.dart';
import '../../view_models/payment_card_cubit/payment_card_cubit.dart';
import '../widgets/checkout_headlines_items.dart';
import '../widgets/payment_method_bottom_sheet.dart';
import '../widgets/payment_method_widget.dart';
import 'add_new_card_page.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  Widget _buildPaymentMethodItem(
    CheckoutCubit cubit,
    PaymentCardModel? card,
    BuildContext context,
  ) {
    if (card == null) {
      return EmptyShippingPayment(
        title: "Payment",
        onTap: () {
          final paymentCubit = PaymentCardCubit();
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: paymentCubit,
                    child: const AddNewCardPage(),
                  ),
                ),
              )
              .then((_) => cubit.getCheckoutData());
        },
      );
    } else {
      return PaymentMethodWidget(
        paymentCard: card,
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) {
              return BlocProvider(
                create: (context) {
                  final cubit = PaymentCardCubit();
                  cubit.fetchPaymentCards();
                  return cubit;
                },
                child: const PaymentMethodBottomSheet(),
              );
            },
          ).then((value) => cubit.getCheckoutData());
        },
      );
    }
  }

  Widget _buildAddressMethodItem(
    CheckoutCubit cubit,
    AddressModel? address,
    BuildContext context,
  ) {
    if (address == null) {
      return EmptyShippingPayment(
        title: "Address",
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.addressRoute)
              .then((value) => cubit.getCheckoutData());
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primaryLight, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: address.image,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${address.city}, ${address.country}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CheckoutCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        bloc: cubit,
        buildWhen: (previous, current) =>
            current is CheckoutLoaded ||
            current is CheckoutError ||
            current is CheckoutLoading,
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CheckoutLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckoutHeadlinesItems(
                          title: "Shipping Address",
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.addressRoute)
                                .then((value) => cubit.getCheckoutData());
                          },
                        ),
                        _buildAddressMethodItem(
                          cubit,
                          state.chosenAddress,
                          context,
                        ),

                        const SizedBox(height: 8),
                        CheckoutHeadlinesItems(
                          title: "Products",
                          productsAmount: state.numOfProducts,
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = state.cartItems[index];
                            final product = cartItem.product;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: 72,
                                        width: 72,
                                        color: AppColors.grey2,
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator.adaptive(),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Size: ${cartItem.size.name}  ·  Qty: ${cartItem.quantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.grey,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '\$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),
                        const CheckoutHeadlinesItems(title: "Payment Method"),
                        _buildPaymentMethodItem(
                          cubit,
                          state.chosenCard,
                          context,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                CartSummaryWidget(
                  subtotal: state.totalPrice,
                  isCheckout: true,
                  buttonText: "Proceed to Buy",
                ),
              ],
            );
          } else if (state is CheckoutError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
