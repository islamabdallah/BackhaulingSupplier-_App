// To parse this JSON data, do
//
//     final locationRequestModel = locationRequestModelFromJson(jsonString);

import 'dart:convert';

LocationRequestModel locationRequestModelFromJson(String str) => LocationRequestModel.fromJson(json.decode(str));

String locationRequestModelToJson(LocationRequestModel data) => json.encode(data.toJson());

class LocationRequestModel {
  LocationRequestModel({
    this.name,
    this.contactName,
    this.contactNumber,
    this.governorate,
    this.city,
    this.detailedAddress,
    this.mapAddress,
    this.longitude,
    this.latitude,
    this.userId,
  });

  String name;
  String contactName;
  String contactNumber;
  String governorate;
  String city;
  String detailedAddress;
  String mapAddress;
  double longitude;
  double latitude;
  String userId;

  LocationRequestModel copyWith({
    String name,
    String contactName,
    String contactNumber,
    String governorate,
    String city,
    String detailedAddress,
    String mapAddress,
    double longitude,
    double latitude,
    String userId,
  }) =>
      LocationRequestModel(
        name: name ?? this.name,
        contactName: contactName ?? this.contactName,
        contactNumber: contactNumber ?? this.contactNumber,
        governorate: governorate ?? this.governorate,
        city: city ?? this.city,
        detailedAddress: detailedAddress ?? this.detailedAddress,
        mapAddress: mapAddress ?? this.mapAddress,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        userId: userId ?? this.userId,
      );

  factory LocationRequestModel.fromJson(Map<String, dynamic> json) => LocationRequestModel(
    name: json["Name"] == null ? null : json["Name"],
    contactName: json["ContactName"] == null ? null : json["ContactName"],
    contactNumber: json["ContactNumber"] == null ? null : json["ContactNumber"],
    governorate: json["Governorate"] == null ? null : json["Governorate"],
    city: json["City"] == null ? null : json["City"],
    detailedAddress: json["DetailedAddress"] == null ? null : json["DetailedAddress"],
    mapAddress: json["MapAddress"] == null ? null : json["MapAddress"],
    longitude: json["Longitude"] == null ? null : json["Longitude"].toDouble(),
    latitude: json["Latitude"] == null ? null : json["Latitude"].toDouble(),
    userId: json["UserId"] == null ? null : json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "ContactName": contactName == null ? null : contactName,
    "ContactNumber": contactNumber == null ? null : contactNumber,
    "Governorate": governorate == null ? null : governorate,
    "City": city == null ? null : city,
    "DetailedAddress": detailedAddress == null ? null : detailedAddress,
    "MapAddress": mapAddress == null ? null : mapAddress,
    "Longitude": longitude == null ? null : longitude,
    "Latitude": latitude == null ? null : latitude,
    "UserId": userId == null ? null : userId,
  };
}
