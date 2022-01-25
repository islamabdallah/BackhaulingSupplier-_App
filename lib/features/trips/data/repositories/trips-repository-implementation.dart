import 'dart:convert';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/models/empty_response_model.dart';
import 'package:haulerapp/core/services/local_storage/local_storage_service.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/trips/data/models/trips.dart';
import 'package:haulerapp/features/trips/domain/repositories/trip-repositories.dart';

class TripRepositoryImplementation implements TripRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<TripsModel>> getTripsData () async {
//    LocalStorageService localStorage = LocalStorageService();
    var dataDB =  await DBHelper.getData('cemex_user');
    final userModel = UserModel.fromSqlJson(dataDB[0]);
//    Map<String, String> queryParameter = {
//      'clientId': userModel.id
//    };
    var clientId = userModel.id;

    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: getTrips+'/'+clientId, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      print(res);
//      final _data = RemoteResultModel<String>.fromJson(res);
//      if (_data.success) {
//      final res = [
//        {
//          "id": 2,
//          "truckNumber": "ي ا ج 6542",
//          "sapTruckNumber": "RNT-ي ا ج 6542",
//          "type": "Trailer",
//          "owner": "Cemex",
//          "category": "Rented",
//          "longitude": 29.10133,
//          "latitude": 29.10133,
//          "hasMobileAppInstance": true,
//          "status": "Idle",
//          "tripType": "No Trip Type",
//          "tripStatus": "No Trip Status",
//          "tripStatusDescription": "",
//          "tripStatusKey": "",
//          "pendingTripsCount": 9,
//          "driver": {
//            "id": 2,
//            "driverID": "driver1-Id",
//            "barCode": "barcode1",
//            "name": "driver1",
//            "userName": "driver1",
//            "password": "driver1-pass"
//          },
//          "lastUpdate": "02/08 0:00 AM",
//          "tripDestination": "test1"
//        },
//        {
//          "id": 5,
//          "truckNumber": "ي ب ج 8321\r\n",
//          "sapTruckNumber": "RNT-ي ب ج 8321\r\n  ",
//          "type": "Trailer",
//          "owner": "Cemex",
//          "category": "Rented",
//          "longitude": 30.11,
//          "latitude": 31.11,
//          "hasMobileAppInstance": false,
//          "status": "Idle",
//          "tripType": "No Trip Type",
//          "tripStatus": "No Trip Status",
//          "tripStatusDescription": "",
//          "tripStatusKey": "",
//          "pendingTripsCount": 2,
//          "driver": {
//            "id": 0,
//            "driverID": null,
//            "barCode": null,
//            "name": "",
//            "userName": null,
//            "password": null
//          },
//          "lastUpdate": "01/04 0:00 AM",
//          "tripDestination": "test2"
//        },
//        {
//          "id": 6,
//          "truckNumber": "ي ب ر 5498\r\n",
//          "sapTruckNumber": "RNT-ي ب ر 5498",
//          "type": "Trailer",
//          "owner": "Cemex",
//          "category": "Rented",
//          "longitude": 31.514211,
//          "latitude": 26.561,
//          "hasMobileAppInstance": false,
//          "status": "Idle",
//          "tripType": "No Trip Type",
//          "tripStatus": "No Trip Status",
//          "tripStatusDescription": "",
//          "tripStatusKey": "",
//          "pendingTripsCount": 1,
//          "driver": {
//            "id": 0,
//            "driverID": null,
//            "barCode": null,
//            "name": "",
//            "userName": null,
//            "password": null
//          },
//          "lastUpdate": "10/24 12:07 PM",
//          "tripDestination": "test3"
//        },
//        {
//          "id": 3,
//          "truckNumber": "ي ا ج 7349",
//          "sapTruckNumber": "RNT-ي ا ج 7349",
//          "type": "Trailer",
//          "owner": "Cemex",
//          "category": "Rented",
//          "longitude": 29.79133,
//          "latitude": 29.91133,
//          "hasMobileAppInstance": true,
//          "status": "OnTrip",
//          "tripType": "Backhauling",
//          "tripStatus": "On-Site",
//          "tripStatusDescription": "",
//          "tripStatusKey": "4_On_Site",
//          "pendingTripsCount": 2,
//          "driver": {
//            "id": 2,
//            "driverID": "driver1-Id",
//            "barCode": "barcode1",
//            "name": "driver1",
//            "userName": "driver1",
//            "password": "driver1-pass"
//          },
//          "lastUpdate": "01/06 4:40 AM",
//          "tripDestination": "loc5-Assuit"
//        },
//        {
//          "id": 4,
//          "truckNumber": "ي ب ج 5312\r\n",
//          "sapTruckNumber": "RNT-ي ب ج 5312\r\n",
//          "type": "Trailer",
//          "owner": "Cemex",
//          "category": "Rented",
//          "longitude": 29.71133,
//          "latitude": 29.91133,
//          "hasMobileAppInstance": false,
//          "status": "Idle",
//          "tripType": "No Trip Type",
//          "tripStatus": "No Trip Status",
//          "tripStatusDescription": "",
//          "tripStatusKey": "",
//          "pendingTripsCount": 0,
//          "driver": {
//            "id": 2,
//            "driverID": "driver1-Id",
//            "barCode": "barcode1",
//            "name": "driver1",
//            "userName": "driver1",
//            "password": "driver1-pass"
//          },
//          "lastUpdate": "01/07 0:00 AM",
//          "tripDestination": "test4"
//        }
//      ];
      TripsModel newData=  TripsModel.fromJson({"data":res});

      print(newData.data);
      return Result(data: newData);
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
  }

}
