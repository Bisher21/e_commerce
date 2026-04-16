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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  height: 140,
                  width: double.infinity,
                  color: AppColors.grey2,
                  child: CachedNetworkImage(
                    imageUrl: productItem.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                        return const Padding(
                          padding: EdgeInsets.all(7),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      } else if (state is SetFavoriteDone) {
                        return InkWell(
                          onTap: () => homeCubit.setFavorite(productItem),
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Icon(
                              state.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: state.isFavorite
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                        );
                      }
                      return InkWell(
                        onTap: () => homeCubit.setFavorite(productItem),
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Icon(
                            productItem.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: productItem.isFavorite
                                ? AppColors.primary
                                : Colors.grey.shade400,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productItem.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    productItem.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${productItem.price}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
