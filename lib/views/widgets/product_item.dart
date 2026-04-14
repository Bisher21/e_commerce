import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/view_models/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 135,
                width: double.infinity,
                color: AppColors.grey2, // Light grey background
                child: CachedNetworkImage(
                  imageUrl: productItem.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator.adaptive(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white38,
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: homeCubit,
                  buildWhen: (previous, current) =>
                      (current is SetFavoriteDone &&
                          current.productId == productItem.id) ||
                      (current is SetFavoriteError &&
                          current.productId == productItem.id) ||
                      (current is SetFavoriteLoading &&
                          current.productId == productItem.id),
                  builder: (context, state) {
                    if (state is SetFavoriteLoading) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is SetFavoriteDone) {
                      return InkWell(
                        onTap: () {
                          homeCubit.setFavorite(productItem);
                        },
                        child: state.isFavorite
                            ? const Icon(
                                Icons.favorite,
                                color: AppColors.primary,
                              )
                            : const Icon(Icons.favorite_border),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        homeCubit.setFavorite(productItem);
                      },
                      child: productItem.isFavorite
                          ? const Icon(Icons.favorite, color: AppColors.primary)
                          : const Icon(Icons.favorite_border),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Text(
          productItem.name,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          productItem.category,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: AppColors.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        Text(
          '\$${productItem.price}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
