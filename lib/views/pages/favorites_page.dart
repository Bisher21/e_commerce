import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FavoriteCubit>(context);

    return  BlocBuilder<FavoriteCubit, FavoriteState>(
        buildWhen: (previous, current) =>
            current is FetchingFavorites ||
            current is FetchingFavoritesDone ||
            current is FetchingFavoritesError,
        builder: (context, state) {
          if (state is FetchingFavorites) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is FetchingFavoritesDone) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Text("You have no favorite products yet."),
              );
            }

            return RefreshIndicator(
              onRefresh: () => cubit.getFavoriteProducts(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.favorites.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: BlocBuilder<FavoriteCubit, FavoriteState>(
                        buildWhen: (previous, current) =>
                            (current is RemovingFavorite &&
                                current.productId == product.id) ||
                            (current is FavoriteRemoved &&
                                current.productId == product.id) ||
                            (current is RemovingFavoriteError &&
                                previous is RemovingFavorite &&
                                previous.productId == product.id),
                        builder: (context, state) {
                          if (state is RemovingFavorite &&
                              state.productId == product.id) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          return IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => cubit.removeFavorite(product.id),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is FetchingFavoritesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },

    );
  }
}
