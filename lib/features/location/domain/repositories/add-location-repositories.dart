import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/features/location/data/models/location-request.dart';
// TODO: I comment this class , till the API is ready @azhar

abstract class AddLocationRepository {
  Future<Result<dynamic>> getLocationRequestData();
  Future<Result<RemoteResultModel<String>>> saveLocationData(LocationRequestModel requestData);
}
