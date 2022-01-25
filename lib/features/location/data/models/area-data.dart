// To parse this JSON data, do
//
//     final areasModel = areasModelFromJson(jsonString);

import 'dart:convert';

AreaDataModel areasModelFromJson(String str) => AreaDataModel.fromJson(json.decode(str));

String areasModelToJson(AreaDataModel data) => json.encode(data.toJson());

class AreaDataModel {
  AreaDataModel({
    this.governorates,
  });

  List<Governorate> governorates;

  AreaDataModel copyWith({
    List<Governorate> governorates,
  }) =>
      AreaDataModel(
        governorates: governorates ?? this.governorates,
      );

  factory AreaDataModel.fromJson(Map<String, dynamic> json) => AreaDataModel(
    governorates: json["governorates"] == null ? null : List<Governorate>.from(json["governorates"].map((x) => Governorate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "governorates": governorates == null ? null : List<dynamic>.from(governorates.map((x) => x.toJson())),
  };
}

class Governorate {
  Governorate({
    this.id,
    this.nameEn,
    this.nameAr,
    this.longitude,
    this.latitude,
    this.cities,
  });

  int id;
  String nameEn;
  String nameAr;
  double longitude;
  double latitude;
  List<City> cities;

  Governorate copyWith({
    int id,
    String nameEn,
    String nameAr,
    double longitude,
    double latitude,
    List<City> cities,
  }) =>
      Governorate(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        cities: cities ?? this.cities,
      );

  factory Governorate.fromJson(Map<String, dynamic> json) => Governorate(
    id: json["id"] == null ? null : json["id"],
    nameEn: json["nameEN"] == null ? null : json["nameEN"],
    nameAr: json["nameAR"] == null ? null : json["nameAR"],
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    cities: json["cities"] == null ? null : List<City>.from(json["cities"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "nameEN": nameEn == null ? null : nameEn,
    "nameAR": nameAr == null ? null : nameAr,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
    "cities": cities == null ? null : List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}

class City {
  City({
    this.id,
    this.nameEn,
    this.nameAr,
    this.governorateId,
    this.governorate,
    this.longitude,
    this.latitude,
  });

  int id;
  String nameEn;
  String nameAr;
  int governorateId;
  dynamic governorate;
  double longitude;
  double latitude;

  City copyWith({
    int id,
    String nameEn,
    String nameAr,
    int governorateId,
    dynamic governorate,
    double longitude,
    double latitude,
  }) =>
      City(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        governorateId: governorateId ?? this.governorateId,
        governorate: governorate ?? this.governorate,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"] == null ? null : json["id"],
    nameEn: json["nameEN"] == null ? null : json["nameEN"],
    nameAr: json["nameAR"] == null ? null : json["nameAR"],
    governorateId: json["governorateId"] == null ? null : json["governorateId"],
    governorate: json["governorate"],
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "nameEN": nameEn == null ? null : nameEn,
    "nameAR": nameAr == null ? null : nameAr,
    "governorateId": governorateId == null ? null : governorateId,
    "governorate": governorate,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
  };
}
