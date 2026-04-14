import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/view_models/location_cubit/location_cubit.dart';
import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce/views/pages/add_new_card_page.dart';
import 'package:e_commerce/views/pages/check_out_page.dart';
import 'package:e_commerce/views/pages/custom_bottom_navbar.dart';
import 'package:e_commerce/views/pages/login_page.dart';
import 'package:e_commerce/views/pages/product_details_page.dart';
import 'package:e_commerce/views/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/checkout_cubit/checkout_cubit.dart';
import '../view_models/payment_card_cubit/payment_card_cubit.dart';
import '../views/pages/address_page.dart';

class AppRouters {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CustomBottomNavbar(),
        );
      case AppRoutes.loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginPage(),
          ),
        );
      case AppRoutes.registerRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const RegisterPage(),
          ),
        );
      case AppRoutes.productDetailsRoute:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductDetailsCubit();
              cubit.getProductDetail(productId);
              return cubit;
            },
            child: const ProductDetailsPage(),
          ),
        );
      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => CheckoutCubit()..getCheckoutData(),
            child: const CheckOutPage(),
          ),
        );
      // case AppRoutes.addNewCardRoute:
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (_) => BlocProvider(
      //       create: (context) => PaymentCardCubit(),
      //       child: const AddNewCardPage(),
      //     ),
      //   );
      case AppRoutes.addressRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => LocationCubit()..fetchLocations(),
            child: const AddressPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Error While Fetching The page")),
          ),
        );
    }
  }
}
