// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.id,
    this.name,
    this.governorate,
    this.city,
    this.detailedAddress,
    this.mapAddress,
    this.longitude,
    this.latitude,
    this.userId,
    this.active,
    this.contactLocationId,
    this.locationContact,
    this.contactName,
    this.contactNumber,
  });

  int id;
  String name;
  String governorate;
  String city;
  String detailedAddress;
  String mapAddress;
  double longitude;
  double latitude;
  String userId;
  bool active;
  int contactLocationId;
  String locationContact;
  String contactName;
  String contactNumber;

  LocationModel copyWith({
    int id,
    String name,
    String governorate,
    String city,
    String detailedAddress,
    String mapAddress,
    String longitude,
    String latitude,
    String userId,
    bool active,
    int contactLocationId,
    String locationContact,
    String contactName,
    String contactNumber,
  }) =>
      LocationModel(
          id: id ?? this.id,
          name: name ?? this.name,
          governorate: governorate ?? this.governorate,
          city: city ?? this.city,
          detailedAddress: detailedAddress ?? this.detailedAddress,
          mapAddress: mapAddress ?? this.mapAddress,
          longitude: longitude ?? this.longitude,
          latitude: latitude ?? this.latitude,
          userId: userId ?? this.userId,
          active: active ?? this.active,
          contactLocationId: contactLocationId ?? this.contactLocationId,
          locationContact: locationContact ?? this.locationContact,
          contactName: contactName ?? this.contactName,
          contactNumber: contactNumber ?? this.contactNumber
      );

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    governorate: json["governorate"] == null ? null : json["governorate"],
    city: json["city"] == null ? null : json["city"],
    detailedAddress: json["detailedAddress"] == null ? null : json["detailedAddress"],
    mapAddress: json["mapAddress"] == null ? null : json["mapAddress"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    userId: json["userId"] == null ? null : json["userId"],
    active: json["active"] == null ? null : json["active"],
    contactLocationId: json["contactLocationId"] == null ? null : json["contactLocationId"],
    locationContact: json["locationContact"] == null ? null : json["locationContact"],
    contactName: json["contactName"] == null ? null : json["contactName"],
    contactNumber: json["contactNumber"] == null ? null : json["contactNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "governorate": governorate == null ? null : governorate,
    "city": city == null ? null : city,
    "detailedAddress": detailedAddress == null ? null : detailedAddress,
    "mapAddress": mapAddress == null ? null : mapAddress,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
    "userId": userId == null ? null : userId,
    "active": active == null ? null : active,
    "contactLocationId": contactLocationId == null ? null : contactLocationId,
    "locationContact": locationContact == null ? null : locationContact,
    "contactName": contactName == null ? null : contactName,
    "contactNumber": contactNumber == null ? null :contactNumber,
  };
}
