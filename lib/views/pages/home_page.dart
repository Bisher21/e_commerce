import 'package:e_commerce/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../view_models/category_cubit/category_cubit.dart';

import '../widgets/category_tap_view.dart';
import '../widgets/home_tap_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              unselectedLabelColor: AppColors.grey,
              tabs: const [Text("Home"), Text("Category")],
            ),

            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const HomeTapView(),
                  BlocProvider(
                    create: (context) {
                      final cubit = CategoryCubit();
                      cubit.fetchCategories();

                      return cubit;
                    },
                    child: const CategoryTapView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
