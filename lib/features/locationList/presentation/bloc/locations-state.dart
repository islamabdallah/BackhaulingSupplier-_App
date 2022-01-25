import 'package:haulerapp/core/errors/base_error.dart';
import 'package:haulerapp/features/request/data/models/request.dart';

class BaseLocationsState {}

class LocationsSuccessState extends BaseLocationsState {

  dynamic locationsData;

  LocationsSuccessState({this.locationsData});
}

class LocationsLoadingState extends BaseLocationsState {}

class LocationsInitLoading extends BaseLocationsState {}

class LocationsFailedState extends BaseLocationsState {
  final BaseError error;
  LocationsFailedState(this.error);
}

class LocationsSaveState extends BaseLocationsState {}
