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
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                "Detail Product",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.grey2),
                  height: size.height * 0.53,
                  width: double.infinity,

                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.1),

                      CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: size.height * 0.41,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.47),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.yellow,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        product.averageRate.toString(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocBuilder<
                                ProductDetailsCubit,
                                ProductDetailsState
                              >(
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
                          const SizedBox(height: 16.0),
                          Text(
                            "Size",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is SelectedSize ||
                                current is ProductDetailsLoaded,
                            builder: (context, state) {
                              return Row(
                                children: ProductSize.values
                                    .map(
                                      (itemSize) => Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                          right: 8,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            cubit.selectSize(itemSize);
                                          },
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color:
                                                  state is SelectedSize &&
                                                      state.size == itemSize
                                                  ? AppColors.primary
                                                  : AppColors.grey2,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Text(
                                                itemSize.name,
                                                style: TextStyle(
                                                  color:
                                                      state is SelectedSize &&
                                                          state.size == itemSize
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.black45),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: AppColors.grey),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\$',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        TextSpan(
                                          text: product.price.toStringAsFixed(
                                            2,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              BlocBuilder<
                                ProductDetailsCubit,
                                ProductDetailsState
                              >(
                                bloc: cubit,
                                buildWhen: (previous, current) =>
                                    current is ProductAddedToCart ||
                                    current is ProductAddingToCart,
                                builder: (context, state) {
                                  if (state is ProductAddingToCart) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                      ),
                                      onPressed: null,
                                      child:
                                          const CircularProgressIndicator.adaptive(),
                                    );
                                  } else if (state is ProductAddedToCart) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                      ),
                                      onPressed: null,
                                      child: const Text("Added To Cart"),
                                    );
                                  }
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (cubit.sizeOfItem != null) {
                                        cubit.addToCart(product.id);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  "Please select a size first!",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: AppColors.primary,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(16),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 22,
                                    ),
                                    label: const Text("Add to Cart"),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductDetailsError) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
