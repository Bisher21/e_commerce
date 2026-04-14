import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_colors.dart';
import '../../view_models/category_cubit/category_cubit.dart';


class CategoryTapView extends StatelessWidget {
  const CategoryTapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: BlocProvider.of<CategoryCubit>(context),
      buildWhen: (previous, current) =>
          current is CategoryLoading ||
          current is CategoryLoaded ||
          current is CategoryLoadedError,
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is CategoryLoaded) {
          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () {
                    debugPrint("preeesssed");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          //BOTTOM
                          CachedNetworkImage(
                            imageUrl: category.imgUrl,
                            fit: BoxFit.cover,
                          ),

                          // MIDDLE LAYER
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.black.withAlpha(95),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          //TOP LAYER
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.title,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${category.productsCount} Items',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white70),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is CategoryLoadedError) {
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
