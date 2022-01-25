import 'dart:convert';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/location/data/models/area-data.dart';
import 'package:haulerapp/features/location/data/models/location-info.dart';
import 'package:haulerapp/features/location/data/models/location-request.dart';
import 'package:haulerapp/features/location/domain/repositories/add-location-repositories.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// TODO: I comment this class , till the API is ready @Azhar
class AddLocationRepositoryImplementation implements AddLocationRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<dynamic>> getLocationRequestData () async {
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
    var clientId = userModel.id;

    final response = await CoreRepository.request(url: newLocation, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
//      final _data = RemoteResultModel<String>.fromJson(res);
//      if (_data.success) {
//      AreaDataModel newData=  AreaDataModel.fromJson(res);
      LocationInfoModel newData=  LocationInfoModel.fromJson(res);
        return Result(data: newData);
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
  }

  @override
  Future<Result<RemoteResultModel<String>>> saveLocationData(LocationRequestModel requestData) async {
    print (requestData);
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
    var clientId = userModel.id;
    requestData.userId = clientId;
    // TODO: implement registerTruckNumber
    var finalLocation = requestData.toJson();
    print(finalLocation);
    final response = await CoreRepository.request(url: newLocation,method: HttpMethod.POST, converter: null, data: finalLocation);
    if(response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if(_data.success) {
        return Result(data: _data);
      }  else {
        final msg =  translator.currentLanguage == 'en' ?_data.msgEN :_data.msgAR;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
    final msg =  translator.currentLanguage == 'en' ? response.error.toString() : 'يوجد خطأ برجاء المحاوله مره ثانيه';
    return Result(error: CustomError(message: msg));
    }
  }
}
