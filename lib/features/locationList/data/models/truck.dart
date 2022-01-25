// To parse this JSON data, do
//
//     final truck = truckFromJson(jsonString);

import 'dart:convert';

Truck truckFromJson(String str) => Truck.fromJson(json.decode(str));

String truckToJson(Truck data) => json.encode(data.toJson());

class Truck {
  Truck({
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
    this.driverName,
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
  String driver;
  String lastUpdate;
  String tripDestination;
  String imageUrl;
  String driverName;

  Truck copyWith({
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
    String driver,
    String lastUpdate,
    String tripDestination,
    String imageUrl,
    String driverName,
  }) =>
      Truck(
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
        driverName: driverName ?? this.driverName,
      );

  factory Truck.fromJson(Map<String, dynamic> json) => Truck(
    id: json["id"],
    truckNumber: json["truckNumber"],
    sapTruckNumber: json["sapTruckNumber"],
    type: json["type"],
    owner: json["owner"],
    category: json["category"],
    longitude: json["longitude"].toDouble(),
    latitude: json["latitude"].toDouble(),
    hasMobileAppInstance: json["hasMobileAppInstance"],
    status: json["status"],
    tripType: json["tripType"],
    tripStatus: json["tripStatus"],
    tripStatusDescription: json["tripStatusDescription"],
    tripStatusKey: json["tripStatusKey"],
    pendingTripsCount: json["pendingTripsCount"],
    driver: json["driver"],
    lastUpdate: json["lastUpdate"],
    tripDestination: json["tripDestination"],
    imageUrl: json["imageUrl"],
    driverName: json["driverName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "truckNumber": truckNumber,
    "sapTruckNumber": sapTruckNumber,
    "type": type,
    "owner": owner,
    "category": category,
    "longitude": longitude,
    "latitude": latitude,
    "hasMobileAppInstance": hasMobileAppInstance,
    "status": status,
    "tripType": tripType,
    "tripStatus": tripStatus,
    "tripStatusDescription": tripStatusDescription,
    "tripStatusKey": tripStatusKey,
    "pendingTripsCount": pendingTripsCount,
    "driver": driver,
    "lastUpdate": lastUpdate,
    "tripDestination": tripDestination,
    "imageUrl": imageUrl,
    "driverName": driverName,
  };
}
