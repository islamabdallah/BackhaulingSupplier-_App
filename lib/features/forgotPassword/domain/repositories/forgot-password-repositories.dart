import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
// TODO: I comment this class , till the API is ready @azhar

abstract class  ForgotPasswordRepository {
  Future<Result<RemoteResultModel<String>>>  forgotPasswordUser(UserModel userModel);
}
