import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/request/data/models/request.dart';
// TODO: I comment this class , till the API is ready @Azhar

abstract class RequestRepository {
  Future<Result<dynamic>> getRequestData();
  Future<Result<RemoteResultModel<String>>> saveRequestData(RequestModel requestData);
}
