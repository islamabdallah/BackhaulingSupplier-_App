import 'dart:convert';

import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/services/local_storage/local_storage_service.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/login/domain/repositories/user-repositories.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// TODO: I comment this class , till the API is ready @Abeer
class LoginRepositoryImplementation implements UserRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<dynamic>>> loginUser (UserModel userModel) async {
    LocalStorageService localStorage = LocalStorageService();
    print( userModel.toJson());
    var userData = {
      "Email": userModel.email,
      "Password": userModel.password
    };
    print(userData);
    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: loginUrl, method: HttpMethod.POST, converter: null, data:userData);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel.fromJson(res);
      if (_data.success) {
        final res = _data.data;
        var user = UserModel.fromJson(res);
        var data =  user.toJson();
        data['isActive'] =  user.isActive ? 1: 0;
        DBHelper.insert('cemex_user', data);
        return Result(data: _data);
      } else {
       final msg =  translator.currentLanguage == 'en' ?_data.msgEN :_data.msgAR;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
      print('herr${response.error.toString()}');
      return Result(error: CustomError(message:response.error.toString()));
    }
   // return Result(data: EmptyResultModel());

  }
}
