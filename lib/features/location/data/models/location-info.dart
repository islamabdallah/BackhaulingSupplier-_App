import 'dart:convert';
import 'area-data.dart';


LocationInfoModel locationInfoModelFromJson(String str) => LocationInfoModel.fromJson(json.decode(str));

String locationInfoModelToJson(LocationInfoModel data) => json.encode(data.toJson());

class LocationInfoModel {
  LocationInfoModel({
    this.governorates,
    this.cities,
  });

  List<Governorate> governorates;
  List<City> cities;

  LocationInfoModel copyWith({
    List<Governorate> governorates,
    List<City> cities
  }) =>
      LocationInfoModel(
        governorates: governorates ?? this.governorates,
        cities: cities ?? this.cities,
      );

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) => LocationInfoModel(
    governorates: json["governorates"] == null ? null : List<Governorate>.from(json["governorates"].map((x) => Governorate.fromJson(x))),
    cities: json["cities"] == null ? null : List<City>.from(json["cities"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "governorates": governorates == null ? null : List<dynamic>.from(governorates.map((x) => x.toJson())),
    "cities": cities == null ? null : List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}

