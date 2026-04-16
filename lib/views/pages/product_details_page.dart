import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/counter_widget_details_page.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductDetailsLoaded ||
          current is ProductDetailsLoading ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: AppColors.grey1,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                "Product Details",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [

                Container(
                  height: size.height * 0.50,
                  width: double.infinity,
                  color: AppColors.grey2,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.1),
                      CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: size.height * 0.38,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.44),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.yellow,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          product.averageRate.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "(128 reviews)",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProductDetailsCubit,
                                  ProductDetailsState>(
                                bloc: cubit,
                                buildWhen: (previous, current) =>
                                    current is QuantityCounterLoaded ||
                                    current is ProductDetailsLoaded,
                                builder: (context, state) {
                                  if (state is QuantityCounterLoaded) {
                                    return CounterWidgetDetailsPage(
                                      value: state.value,
                                      productId: product.id,
                                      cubit:
                                          BlocProvider.of<ProductDetailsCubit>(
                                            context,
                                          ),
                                    );
                                  } else if (state is ProductDetailsLoaded) {
                                    return CounterWidgetDetailsPage(
                                      value: 1,
                                      productId: product.id,
                                      cubit:
                                          BlocProvider.of<ProductDetailsCubit>(
                                            context,
                                          ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),


                          Divider(color: Colors.grey.shade100, thickness: 1),
                          const SizedBox(height: 16),


                          Text(
                            "Select Size",
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1,
                                ),
                          ),
                          const SizedBox(height: 10),
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is SelectedSize ||
                                current is ProductDetailsLoaded,
                            builder: (context, state) {
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ProductSize.values.map((itemSize) {
                                  final isSelected =
                                      state is SelectedSize &&
                                      state.size == itemSize;
                                  return InkWell(
                                    onTap: () => cubit.selectSize(itemSize),
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.grey2,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        itemSize.name,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.white
                                              : Colors.black54,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                          Divider(color: Colors.grey.shade100, thickness: 1),
                          const SizedBox(height: 16),


                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Price",
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(
                                    color: AppColors.grey,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  TextSpan(
                                    text: product.price.toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),


                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          bloc: cubit,
                          buildWhen: (previous, current) =>
                              current is ProductAddedToCart ||
                              current is ProductAddingToCart,
                          builder: (context, state) {
                            if (state is ProductAddingToCart) {
                              return _ctaButton(
                                context,
                                onPressed: null,
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else if (state is ProductAddedToCart) {
                              return _ctaButton(
                                context,
                                onPressed: null,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Added!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return _ctaButton(
                              context,
                              onPressed: () {
                                if (cubit.sizeOfItem != null) {
                                  cubit.addToCart(product.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Please select a size first!",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          );
        } else {
          return const Scaffold(body: SizedBox.shrink());
        }
      },
    );
  }

  Widget _ctaButton(
    BuildContext context, {
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: onPressed == null ? Colors.grey.shade400 : null,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}
