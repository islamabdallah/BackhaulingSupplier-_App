// To parse this JSON data, do
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';
import 'package:haulerapp/features/request/data/models/dropDown-data.dart';
import 'package:haulerapp/features/request/data/models/location.dart';

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  InfoModel({
    this.locations,
    this.unitTypes,
    this.packages,
    this.truckTypes,
  });

  List<LocationModel> locations;
  List<DropDownDataModel> unitTypes;
  List<DropDownDataModel> packages;
  List<DropDownDataModel> truckTypes;

  InfoModel copyWith({
    List<LocationModel> locations,
    List<DropDownDataModel> unitTypes,
    List<DropDownDataModel> packages,
    List<DropDownDataModel> truckTypes,
  }) =>
      InfoModel(
        locations: locations ?? this.locations,
        unitTypes: unitTypes ?? this.unitTypes,
        packages: packages ?? this.packages,
        truckTypes: truckTypes ?? this.truckTypes,
      );

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    locations: json["locations"] == null ? null : List<LocationModel>.from(json["locations"].map((x) => LocationModel.fromJson(x))),
    unitTypes: json["unitTypes"] == null ? null : List<DropDownDataModel>.from(json["unitTypes"].map((x) => DropDownDataModel.fromJson(x))),
    packages: json["packages"] == null ? null : List<DropDownDataModel>.from(json["packages"].map((x) => DropDownDataModel.fromJson(x))),
    truckTypes: json["truckTypes"] == null ? null : List<DropDownDataModel>.from(json["truckTypes"].map((x) => DropDownDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "locations": locations == null ? null : List<dynamic>.from(locations.map((x) => x.toJson())),
    "unitTypes": unitTypes == null ? null : List<dynamic>.from(unitTypes.map((x) => x.toJson())),
    "packages": packages == null ? null : List<dynamic>.from(packages.map((x) => x.toJson())),
    "truckTypes": truckTypes == null ? null : List<dynamic>.from(truckTypes.map((x) => x.toJson())),
  };
}

