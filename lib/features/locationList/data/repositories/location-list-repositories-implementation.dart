import 'dart:convert';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/repositories/core_repository.dart';
import 'package:haulerapp/core/results/result.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/locationList/data/models/trucks.dart';
import 'package:haulerapp/features/locationList/domain/repositories/location-list-repositories.dart';
import 'package:haulerapp/core/services/http_service/http_service.dart';
import 'package:haulerapp/features/login/data/models/user.dart';

// TODO: I comment this class , till the API is ready @Azhar
class LocationListRepositoryImplementation implements LocationListRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<dynamic>> getLocationListData () async {
    var data =  await DBHelper.getData('cemex_user');
    var user = data[0];
    final userModel = UserModel.fromSqlJson(user);
    var clientId = userModel.id;
    final response = await CoreRepository.request(url: getLocations+'/'+clientId, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
//      final _data = RemoteResultModel<String>.fromJson(res);
//      print(_data);
//      if (_data.success) {
//        LocationsModel newData = LocationsModel.fromJson({"data": res});
      TrucksModel newData=  TrucksModel.fromJson({"data":res});

      print(newData.data);
        return Result(data: newData);
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
  }

}
