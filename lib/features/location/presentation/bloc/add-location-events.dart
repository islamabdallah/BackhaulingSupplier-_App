import 'package:haulerapp/features/location/data/models/location-request.dart';

class BaseLocationEvent{}

class GetAreaDataEvent extends BaseLocationEvent{}

class SaveLocationEvent extends BaseLocationEvent {
  final LocationRequestModel requestModel;
  SaveLocationEvent(this.requestModel);
}