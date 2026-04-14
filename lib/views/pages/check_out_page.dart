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
      return Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(48)),
            child: CachedNetworkImage(
              imageUrl: address.image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.city,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${address.city}, ${address.country}"),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CheckoutCubit>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckoutHeadlinesItems(
                            title: "Address",
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

                          const SizedBox(height: 16),

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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(50),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.grey2,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
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
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Size: ${cartItem.size.name}  |  Qty: ${cartItem.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: AppColors.grey,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '\$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
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

                          const SizedBox(height: 16),

                          const CheckoutHeadlinesItems(title: "Payment"),
                          _buildPaymentMethodItem(
                            cubit,
                            state.chosenCard,
                            context,
                          ),
                        ],
                      ),
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
