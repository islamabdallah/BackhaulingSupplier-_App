import 'dart:convert';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:haulerapp/features/requestList/data/models/request-list-data.dart';
import 'package:haulerapp/features/requestList/data/models/review.dart';
import 'package:haulerapp/features/requestList/domain/request-list-repositories.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// TODO: I comment this class , till the API is ready @Azhar
class RequestListRepositoryImplementation implements RequestListRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<dynamic>> getRequestListData (String status) async {
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
    var clientId = userModel.id;
    final urlRequestList = requestList+'/'+clientId+'/'+status;
    final response = await CoreRepository.request(url: urlRequestList, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
//      final _data = RemoteResultModel<String>.fromJson(res);
//      if (_data.success) {
//      AreaDataModel newData=  AreaDataModel.fromJson(res);
      RequestListDataModel newData=  RequestListDataModel.fromJson(res);
        return Result(data: newData);
    }
    if (response.hasErrorOnly) {

      final msg =  translator.currentLanguage == 'en' ? response.error.toString() : 'يوجد خطأ برجاء المحاوله مره ثانيه';
      return Result(error: CustomError(message: msg));
    }
  }

  @override
  Future<Result<RemoteResultModel<String>>> cancelRequest(Request requestData) async {
    print (requestData);
    final urlCancelRequestList = cancelRequestUrl+'/${requestData.id}';
    final response = await CoreRepository.request(url: urlCancelRequestList,method: HttpMethod.GET, converter: null,);
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
  @override
  Future<Result<RemoteResultModel<String>>> reviewRequest(ReviewModel reviewData) async{
    var finalT = reviewData.toJson();
    print(finalT);
    final response = await CoreRepository.request(url: reviewRequestUrl,method: HttpMethod.POST, converter: null, data: finalT);
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
