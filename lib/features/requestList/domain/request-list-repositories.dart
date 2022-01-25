import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/features/location/data/models/location-request.dart';
import 'package:haulerapp/features/requestList/data/models/request-list-data.dart';
import 'package:haulerapp/features/requestList/data/models/review.dart';
// TODO: I comment this class , till the API is ready @azhar

abstract class RequestListRepository {
  Future<Result<dynamic>> getRequestListData(String status);
  Future<Result<RemoteResultModel<String>>> cancelRequest(Request requestData);
  Future<Result<RemoteResultModel<String>>> reviewRequest(ReviewModel reviewData);
}
