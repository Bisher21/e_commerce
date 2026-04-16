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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterCarousel.builder(
                    options: FlutterCarouselOptions(
                      autoPlay: true,
                      height: 190.0,
                      showIndicator: true,
                      slideIndicator: CircularWaveSlideIndicator(),
                      viewportFraction: 1.0,
                    ),
                    itemCount: state.carouselItems.length,
                    itemBuilder: (
                      BuildContext context,
                      int itemIndex,
                      int pageViewIndex,
                    ) => Padding(
                      padding: const EdgeInsetsDirectional.only(end: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CachedNetworkImage(
                          imageUrl: state.carouselItems[itemIndex].imgUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Arrivals",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          "${state.products.length} products",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.deepPurple.withValues(
                          alpha: 0.08,
                        ),
                      ),
                      child: Text(
                        "See All",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
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
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 220,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.productDetailsRoute,
                            arguments: state.products[index].id,
                          ),
                      borderRadius: BorderRadius.circular(20),
                      child: ProductItem(productItem: state.products[index]),
                    );
                  },
                ),
                const SizedBox(height: 24),
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
