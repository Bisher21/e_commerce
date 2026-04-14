import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/home_cubit/home_cubit.dart';
import 'package:e_commerce/views/widgets/product_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeTapView extends StatelessWidget {
  const HomeTapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: BlocProvider.of<HomeCubit>(context),
      buildWhen: (previous, current) =>
          current is HomeLoaded ||
          current is HomeLoading ||
          current is HomeError,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                FlutterCarousel.builder(
                  options: FlutterCarouselOptions(
                    autoPlay: true,
                    height: 200.0,
                    showIndicator: true,
                    slideIndicator: CircularWaveSlideIndicator(),
                  ),
                  itemCount: state.carouselItems.length,
                  itemBuilder:
                      (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                      ) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: CachedNetworkImage(
                            imageUrl: state.carouselItems[itemIndex].imgUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator.adaptive(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Arrivals",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "See All",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  itemCount: state.products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 210,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.productDetailsRoute,
                            arguments: state.products[index].id,
                          ),
                      child: ProductItem(productItem: state.products[index]),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is HomeError) {
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
