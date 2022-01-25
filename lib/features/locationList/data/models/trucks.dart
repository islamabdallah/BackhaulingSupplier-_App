import 'dart:convert';

import 'package:haulerapp/features/locationList/data/models/truck.dart';

TrucksModel trucksModelFromJson(String str) => TrucksModel.fromJson(json.decode(str));

String trucksModelToJson(Truck data) => json.encode(data.toJson());
class TrucksModel {
  TrucksModel({
    this.data,
  });

  List<Truck> data;

  TrucksModel copyWith({
    List<Truck> data,
  }) =>
      TrucksModel(
        data: data ?? this.data,
      );

  factory TrucksModel.fromJson(Map<String, dynamic> json) => TrucksModel(
    data: json["data"] == null ? null : List<Truck>.from(json["data"].map((x) => Truck.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}