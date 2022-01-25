import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
// TODO: I comment this class , till the API is ready @Abeer

abstract class UserRepository {
  Future<Result<RemoteResultModel<dynamic>>> loginUser(UserModel userModel);
}
