import 'dart:convert';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:haulerapp/features/request/data/models/request-info.dart';
import 'package:haulerapp/features/request/data/models/request.dart';
import 'package:haulerapp/features/request/domain/repositories/request-repositories.dart';

// TODO: I comment this class , till the API is ready @Azhar
class RequestRepositoryImplementation implements RequestRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<dynamic>> getRequestData () async {
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
//    LocalStorageService localStorage = LocalStorageService();
    var clientId = userModel.id;
//    Map<String, String> queryParameter = {
//      'clientId': clientId
//    };
//    print(queryParameter);
    final response = await CoreRepository.request(url: getRequest+'/'+clientId, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
//      final _data = RemoteResultModel<String>.fromJson(res);
//      if (_data.success) {
        InfoModel newData=  InfoModel.fromJson(res);
        return Result(data: newData);
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
//  var testData = {
//      "locations": [
//        {
//          "id": 3020,
//          "name": "loc1",
//          "governorate": "Asyut",
//          "city": "Asyut1",
//          "detailedAddress": "detailed address",
//          "mapAddress": "Youlio 23, Al Hamraa Ath Thaneyah, Asyut Second, Assiut Governorate, Egypt",
//          "longitude": "31.186306",
//          "latitude": "27.179476",
//          "userId": "cb5977e4-6640-44d1-bf11-ecea77c01725",
//          "active": true,
//          "contactLocationId": 22,
//          "locationContact": null
//        },
//      ],
//      "truckTypes": [
//        {
//          "id": 1,
//          "nameEN": "Trailer",
//          "nameAR": "مقطوره",
//          "active": true
//        },
//        {
//          "id": 2,
//          "nameEN": "Double Vehicle",
//          "nameAR": "مركبة مزدوجة",
//          "active": true
//        }
//      ],
//      "packages": [
//        {
//          "id": 1,
//          "nameEN": "Shipment",
//          "nameAR": "شحنه",
//          "active": true
//        },
//        {
//          "id": 2,
//          "nameEN": "Unit",
//          "nameAR": "وحده",
//          "active": true
//        }
//      ],
//      "unitTypes": [
//        {
//          "id": 1,
//          "nameEN": "UnitA",
//          "nameAR": "وحده أ",
//          "active": true
//        },
//        {
//          "id": 2,
//          "nameEN": "UnitB",
//          "nameAR": "وحده ب",
//          "active": true
//        }
//      ]
//    };
//    InfoModel newData=  InfoModel.fromJson(testData);
//    print(newData.locations.first.longitude);
//
//    return Result(data: testData);
  }

  @override
  Future<Result<RemoteResultModel<String>>> saveRequestData(RequestModel requestData) async {
    print (requestData);
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
    var clientId = userModel.id;
    requestData.clientId = clientId;
    // TODO: implement registerTruckNumber
    final response = await CoreRepository.request(url: saveRequest,method: HttpMethod.POST, converter: null, data: requestData.toJson());
    if(response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if(_data.success) {
        return Result(data: _data);
      } else {
        return Result(error: CustomError(message:_data.msgEN ));
      }
    }
    if(response.hasErrorOnly) {
      return Result(error: response.error);
    }
  }
}
