part of 'location_cubit.dart';


sealed class LocationState {}

final class LocationInitial extends LocationState {}


final class FetchingLocations extends LocationState {}

final class LocationsFetched extends LocationState{
  final List<AddressModel> locations;

  LocationsFetched({required this.locations});
}

final class FetchingLocationsFailed extends LocationState{
  final String message;

  FetchingLocationsFailed(this.message);
}
final class AddingLocation extends LocationState {}

final class LocationAdded extends LocationState {}

final class AddingLocationFailed extends LocationState {
  final String message;

  AddingLocationFailed(this.message);
}

final class LocationChosen extends LocationState {
  final AddressModel location;

  LocationChosen({required this.location});
}

final class LocationButtonConfirming extends LocationState {}

final class LocationButtonConfirmed extends LocationState {}

final class LocationButtonConfirmingFailed extends LocationState {

  final String message;

  LocationButtonConfirmingFailed({required this.message});
}

