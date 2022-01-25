import 'package:haulerapp/core/errors/base_error.dart';
import 'package:haulerapp/features/trips/data/models/trips.dart';

class BaseTripState {}

class TripSuccessState extends BaseTripState {

  TripsModel trips;

  TripSuccessState({this.trips});
}

class TripLoadingState extends BaseTripState {}

class TripInitLoading extends BaseTripState {}

class TripFailedState extends BaseTripState {
  final BaseError error;
  TripFailedState(this.error);
}

class TripSaveState extends BaseTripState {}
