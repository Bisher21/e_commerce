import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/address_model.dart';
import '../../services/auth_services.dart';
import '../../services/location_services.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  String? selectedId;
  AddressModel? selectedLocationItem;
  final locationService = LocationServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();

  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final locations = await locationService.fetchLocations(
        authServices.currentUser()!.uid,
      );

      for(var location in locations){
        if(location.isSelected){
          selectedId = location.id;
          selectedLocationItem=location;
        }
      }
      if (locations.isEmpty) {
        emit(LocationsFetched(locations: []));
        return;
      }
      selectedId ??= locations.first.id;
      selectedLocationItem ??= locations.first;
      emit(LocationsFetched(locations: locations));
      emit(LocationChosen(location: selectedLocationItem!));
    } catch (e) {
      emit(FetchingLocationsFailed(e.toString()));
    }
  }

  Future<void> addLocation(String location) async {
    emit(AddingLocation());

    try {
      final parts = location.split('-');

      String city = parts[0].trim();
      if (city.isNotEmpty) {
        city = city[0].toUpperCase() + city.substring(1);
      }

      String country = parts[1].trim();
      if (country.isNotEmpty) {
        country = country[0].toUpperCase() + country.substring(1);
      }

      final newAddress = AddressModel(
        id: DateTime.now().toIso8601String(),
        city: city,
        country: country,
      );

      await locationService.setLocation(
        authServices.currentUser()!.uid,
        newAddress,
      );

      emit(LocationAdded());
      final locations = await locationService.fetchLocations(
        authServices.currentUser()!.uid,
      );
      emit(LocationsFetched(locations: locations));
    } catch (e) {
      emit(AddingLocationFailed(e.toString()));
    }
  }

  Future<void> selectedLocation(String id) async {
    selectedId = id;
    try {
      final tempChosenAddress = await locationService.fetchLocation(
        authServices.currentUser()!.uid,
        selectedId!,
      );
selectedLocationItem=tempChosenAddress;
      emit(LocationChosen(location: selectedLocationItem!));
    } catch (e) {
      emit(FetchingLocationsFailed(e.toString()));
    }
  }

  Future<void> confirmAddress() async {
    emit(LocationButtonConfirming());
    try {
      final previousChosenAddress = await locationService.fetchLocations(
        authServices.currentUser()!.uid,
        true,
      );
      if (previousChosenAddress.isNotEmpty) {

        final previousAddress = previousChosenAddress.first.copyWith(isSelected: false);
        await locationService.setLocation(authServices.currentUser()!.uid, previousAddress);
      }


      final updatedAddress = selectedLocationItem!.copyWith(isSelected: true);
      await locationService.setLocation(authServices.currentUser()!.uid, updatedAddress);


      selectedLocationItem = updatedAddress;

      emit(LocationButtonConfirmed());
    } catch (e) {
      emit(LocationButtonConfirmingFailed(message: e.toString()));
    }
  }
}
