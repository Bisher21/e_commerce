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
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 26,
            backgroundImage: CachedNetworkImageProvider(
              'https://randomuser.me/api/portraits/men/46.jpg',
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jack Mith", style: Theme.of(context).textTheme.titleSmall),
            Text(
              "Let's go shopping",
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.grey),
            ),
          ],
        ),
        actions: [
          if (currentIndex == 0) ...[
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          ] else if (currentIndex == 1)
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
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
