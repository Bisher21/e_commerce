import 'package:e_commerce/models/category_model.dart';
import 'package:e_commerce/models/home_carousel_item_model.dart';
import 'package:e_commerce/utils/api_paths.dart';

import '../models/product_item_model.dart';
import 'firestore_services.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
  Future<List<HomeCarouselItem>> fetchAnnouncements();
  Future<List<CategoryModel>> fetchCategories();

}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final result = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }

  @override
  Future<List<HomeCarouselItem>> fetchAnnouncements() async {
    final result = await firestoreServices.getCollection<HomeCarouselItem>(
      path: ApiPaths.announcements(),
      builder: (data, documentId) => HomeCarouselItem.fromMap(data),
    );
    return result;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final result = await firestoreServices.getCollection<CategoryModel>(
      path: ApiPaths.categories(),
      builder: (data, documentId) => CategoryModel.fromMap(data),
    );
    return result;
  }

}
