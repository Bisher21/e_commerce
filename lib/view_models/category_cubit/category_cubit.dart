import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/category_model.dart';
import '../../services/home_services.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  HomeServices homeServices = HomeServicesImpl();
  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await homeServices.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryLoadedError(message: e.toString()));
    }
  }
}
