import 'dart:math';

import 'package:e_commerce/models/address_model.dart';
import 'package:e_commerce/utils/api_paths.dart';

import 'firestore_services.dart';

abstract class LocationServices {
  Future<void> setLocation(String userId, AddressModel location);
  Future<List<AddressModel>> fetchLocations(
    String userId, [
    bool selected = false,
  ]);
  Future<AddressModel> fetchLocation(String userId, String locationId);
}

class LocationServicesImpl implements LocationServices {
  final fireStoreServices = FirestoreServices.instance;
  @override
  Future<void> setLocation(String userId, AddressModel location) async {
    fireStoreServices.setData(
      path: ApiPaths.location(userId, location.id),
      data: location.toMap(),
    );
  }

  @override
  Future<List<AddressModel>> fetchLocations(
    String userId, [
    bool selected = false,
  ]) async {
    final result = await fireStoreServices.getCollection(
      path: ApiPaths.locations(userId),
      builder: (data, documentId) => AddressModel.fromMap(data),
      queryBuilder: selected
          ? (query) => query.where("isSelected", isEqualTo: true)
          : null,
    );
    return result;
  }

  @override
  Future<AddressModel> fetchLocation(String userId, String locationId) async {
    final result = await fireStoreServices.getDocument(
      path: ApiPaths.location(userId, locationId),
      builder: (data, documentId) => AddressModel.fromMap(data),
    );
    return result;
  }
}
