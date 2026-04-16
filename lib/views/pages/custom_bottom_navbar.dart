import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce/views/pages/home_page.dart';

import 'package:e_commerce/views/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../view_models/home_cubit/home_cubit.dart';
import 'favorites_page.dart';
import 'cart_page.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PersistentTabController _controller;
  int currentIndex = 0;
  final CartCubit _cartCubit = CartCubit();
  final FavoriteCubit _favoriteCubit = FavoriteCubit();
  final HomeCubit _homeCubit = HomeCubit();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _homeCubit.fetchHomePageData();
  }

  List<Widget> _buildScreens() {
    return [
      BlocProvider.value(value: _homeCubit, child: const MyHomePage()),
      BlocProvider.value(value: _cartCubit, child: const CartPage()),
      BlocProvider.value(value: _favoriteCubit, child: const FavoritesPage()),
      const ProfilePage(),
    ];
  }

  List<ItemConfig> _navBarsItems() {
    return [
      ItemConfig(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.cart),
        title: ("Cart"),
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.heart),
        title: ("Favorites"),
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: AppColors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(
                'https://randomuser.me/api/portraits/men/46.jpg',
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jack Mith",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              "Let's go shopping 🛍️",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          if (currentIndex == 0) ...[
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ] else if (currentIndex == 1)
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: _buildScreens()[0],
            item: _navBarsItems()[0],
          ),
          PersistentTabConfig(
            screen: _buildScreens()[1],
            item: _navBarsItems()[1],
          ),
          PersistentTabConfig(
            screen: _buildScreens()[2],
            item: _navBarsItems()[2],
          ),
          PersistentTabConfig(
            screen: _buildScreens()[3],
            item: _navBarsItems()[3],
          ),
        ],
        navBarBuilder: (navBarConfig) =>
            Style9BottomNavBar(navBarConfig: navBarConfig),
        controller: _controller,
        onTabChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 0) {
            _homeCubit.fetchHomePageData();
          } else if (index == 1) {
            _cartCubit.getCartItems();
          } else if (index == 2) {
            _favoriteCubit.getFavoriteProducts();
          }
        },
        backgroundColor: AppColors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
