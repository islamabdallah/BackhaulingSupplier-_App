import 'dart:convert';
import 'package:haulerapp/features/trips/data/models/driver.dart';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModel {
  TripModel({
    this.id,
    this.truckNumber,
    this.sapTruckNumber,
    this.type,
    this.owner,
    this.category,
    this.longitude,
    this.latitude,
    this.hasMobileAppInstance,
    this.status,
    this.tripType,
    this.tripStatus,
    this.tripStatusDescription,
    this.tripStatusKey,
    this.pendingTripsCount,
    this.driver,
    this.lastUpdate,
    this.tripDestination,
    this.imageUrl,
  });

  int id;
  String truckNumber;
  String sapTruckNumber;
  String type;
  String owner;
  String category;
  double longitude;
  double latitude;
  bool hasMobileAppInstance;
  String status;
  String tripType;
  String tripStatus;
  String tripStatusDescription;
  String tripStatusKey;
  int pendingTripsCount;
  DriverModel driver;
  String lastUpdate;
  String tripDestination;
  String imageUrl;

  TripModel copyWith({
    int id,
    String truckNumber,
    String sapTruckNumber,
    String type,
    String owner,
    String category,
    double longitude,
    double latitude,
    bool hasMobileAppInstance,
    String status,
    String tripType,
    String tripStatus,
    String tripStatusDescription,
    String tripStatusKey,
    int pendingTripsCount,
    DriverModel driver,
    String lastUpdate,
    String tripDestination,
    String imageUrl,
  }) =>
      TripModel(
        id: id ?? this.id,
        truckNumber: truckNumber ?? this.truckNumber,
        sapTruckNumber: sapTruckNumber ?? this.sapTruckNumber,
        type: type ?? this.type,
        owner: owner ?? this.owner,
        category: category ?? this.category,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        hasMobileAppInstance: hasMobileAppInstance ?? this.hasMobileAppInstance,
        status: status ?? this.status,
        tripType: tripType ?? this.tripType,
        tripStatus: tripStatus ?? this.tripStatus,
        tripStatusDescription: tripStatusDescription ?? this.tripStatusDescription,
        tripStatusKey: tripStatusKey ?? this.tripStatusKey,
        pendingTripsCount: pendingTripsCount ?? this.pendingTripsCount,
        driver: driver ?? this.driver,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        tripDestination: tripDestination ?? this.tripDestination,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    id: json["id"] == null ? null : json["id"],
    truckNumber: json["truckNumber"] == null ? null : json["truckNumber"],
    sapTruckNumber: json["sapTruckNumber"] == null ? null : json["sapTruckNumber"],
    type: json["type"] == null ? null : json["type"],
    owner: json["owner"] == null ? null : json["owner"],
    category: json["category"] == null ? null : json["category"],
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    hasMobileAppInstance: json["hasMobileAppInstance"] == null ? null : json["hasMobileAppInstance"],
    status: json["status"] == null ? null : json["status"],
    tripType: json["tripType"] == null ? null : json["tripType"],
    tripStatus: json["tripStatus"] == null ? null : json["tripStatus"],
    tripStatusDescription: json["tripStatusDescription"] == null ? null : json["tripStatusDescription"],
    tripStatusKey: json["tripStatusKey"] == null ? null : json["tripStatusKey"],
    pendingTripsCount: json["pendingTripsCount"] == null ? null : json["pendingTripsCount"],
    driver: json["driver"] == null ? null : DriverModel.fromJson(json["driver"]),
    lastUpdate: json["lastUpdate"] == null ? null : json["lastUpdate"],
    tripDestination: json["tripDestination"] == null ? null : json["tripDestination"],
      imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "truckNumber": truckNumber == null ? null : truckNumber,
    "sapTruckNumber": sapTruckNumber == null ? null : sapTruckNumber,
    "type": type == null ? null : type,
    "owner": owner == null ? null : owner,
    "category": category == null ? null : category,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
    "hasMobileAppInstance": hasMobileAppInstance == null ? null : hasMobileAppInstance,
    "status": status == null ? null : status,
    "tripType": tripType == null ? null : tripType,
    "tripStatus": tripStatus == null ? null : tripStatus,
    "tripStatusDescription": tripStatusDescription == null ? null : tripStatusDescription,
    "tripStatusKey": tripStatusKey == null ? null : tripStatusKey,
    "pendingTripsCount": pendingTripsCount == null ? null : pendingTripsCount,
    "driver": driver == null ? null : driver.toJson(),
    "lastUpdate": lastUpdate == null ? null : lastUpdate,
    "tripDestination": tripDestination == null ? null : tripDestination,
    "imageUrl": imageUrl == null ? null : imageUrl,
  };
}

