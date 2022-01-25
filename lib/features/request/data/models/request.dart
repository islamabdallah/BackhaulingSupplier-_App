// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);
import 'dart:convert';

RequestModel requestModelFromJson(String str) => RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    this.clientId,
    this.numberOfTrucks,
    this.pickUpDate,
    this.deliverDate,
    this.sourceId,
    this.destinationId,
    this.truckTypeId,
    this.productPackageId,
    this.unitTypeId,
    this.capacity,
    this.accessories,
    this.comment,
  });

  String clientId;
  int numberOfTrucks;
  DateTime pickUpDate;
  DateTime deliverDate;
  int sourceId;
  int destinationId;
  int truckTypeId;
  int productPackageId;
  int unitTypeId;
  int capacity;
  String accessories;
  String comment;

  RequestModel copyWith({
    String clientId,
    int numberOfTrucks,
    DateTime pickUpDate,
    DateTime deliverDate,
    int sourceId,
    int destinationId,
    int truckTypeId,
    int productPackageId,
    int unitTypeId,
    int capacity,
    String accessories,
    String comment,
  }) =>
      RequestModel(
        clientId: clientId ?? this.clientId,
        numberOfTrucks: numberOfTrucks ?? this.numberOfTrucks,
        pickUpDate: pickUpDate ?? this.pickUpDate,
        deliverDate: deliverDate ?? this.deliverDate,
        sourceId: sourceId ?? this.sourceId,
        destinationId: destinationId ?? this.destinationId,
        truckTypeId: truckTypeId ?? this.truckTypeId,
        productPackageId: productPackageId ?? this.productPackageId,
        unitTypeId: unitTypeId ?? this.unitTypeId,
        capacity: capacity ?? this.capacity,
        accessories: accessories ?? this.accessories,
        comment: comment ?? this.comment,
      );

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    clientId: json["clientId"] == null ? null : json["clientId"],
    numberOfTrucks: json["numberOfTrucks"] == null ? null : json["numberOfTrucks"],
    pickUpDate: json["pickUpDate"] == null ? null : DateTime.parse(json["pickUpDate"]),
    deliverDate: json["deliverDate"] == null ? null : DateTime.parse(json["deliverDate"]),
    sourceId: json["sourceId"] == null ? null : json["sourceId"],
    destinationId: json["destinationId"] == null ? null : json["destinationId"],
    truckTypeId: json["truckTypeId"] == null ? null : json["truckTypeId"],
    productPackageId: json["productPackageId"] == null ? null : json["productPackageId"],
    unitTypeId: json["unitTypeId"] == null ? null : json["unitTypeId"],
    capacity: json["capacity"] == null ? null : json["capacity"],
    accessories: json["accessories"] == null ? null : json["accessories"],
    comment: json["comment"] == null ? null : json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "clientId": clientId == null ? null : clientId,
    "numberOfTrucks": numberOfTrucks == null ? null : numberOfTrucks,
    "pickUpDate": pickUpDate == null ? null : pickUpDate.toIso8601String(),
    "deliverDate": deliverDate == null ? null : deliverDate.toIso8601String(),
    "sourceId": sourceId == null ? null : sourceId,
    "destinationId": destinationId == null ? null : destinationId,
    "truckTypeId": truckTypeId == null ? null : truckTypeId,
    "productPackageId": productPackageId == null ? null : productPackageId,
    "unitTypeId": unitTypeId == null ? null : unitTypeId,
    "capacity": capacity == null ? null : capacity,
    "accessories": accessories == null ? null : accessories,
    "comment": comment == null ? null : comment,
  };
}
