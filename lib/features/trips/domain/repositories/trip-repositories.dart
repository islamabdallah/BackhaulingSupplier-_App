import 'package:haulerapp/core/results/result.dart';

abstract class TripRepository {
  Future<Result<dynamic>> getTripsData();
}
