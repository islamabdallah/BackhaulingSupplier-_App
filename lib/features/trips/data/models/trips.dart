import 'dart:convert';
import 'package:haulerapp/features/trips/data/models/trip.dart';

TripsModel tripsModelFromJson(String str) => TripsModel.fromJson(json.decode(str));

String tripsModelToJson(TripsModel data) => json.encode(data.toJson());
class TripsModel {
  TripsModel({
    this.data,
  });

  List<TripModel> data;

  TripsModel copyWith({
    List<TripModel> data,
  }) =>
      TripsModel(
        data: data ?? this.data,
      );

  factory TripsModel.fromJson(Map<String, dynamic> json) => TripsModel(
    data: json["data"] == null ? null : List<TripModel>.from(json["data"].map((x) => TripModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}