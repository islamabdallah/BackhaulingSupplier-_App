// To parse this JSON data, do
//
//     final requestListDataModel = requestListDataModelFromJson(jsonString);

import 'dart:convert';

RequestListDataModel requestListDataModelFromJson(String str) => RequestListDataModel.fromJson(json.decode(str));

String requestListDataModelToJson(RequestListDataModel data) => json.encode(data.toJson());

class RequestListDataModel {
  RequestListDataModel({
    this.count,
    this.requests,
  });

  Count count;
  List<Request> requests;

  RequestListDataModel copyWith({
    Count count,
    List<Request> requests,
  }) =>
      RequestListDataModel(
        count: count ?? this.count,
        requests: requests ?? this.requests,
      );

  factory RequestListDataModel.fromJson(Map<String, dynamic> json) => RequestListDataModel(
    count: json["count"] == null ? null : Count.fromJson(json["count"]),
    requests: json["requests"] == null ? null : List<Request>.from(json["requests"].map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count.toJson(),
    "requests": requests == null ? null : List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class Count {
  Count({
    this.pending,
    this.approved,
    this.assigned,
    this.rejected,
    this.completed,
    this.canceled,
  });

  int pending;
  int approved;
  int assigned;
  int rejected;
  int completed;
  int canceled;

  Count copyWith({
    int pending,
    int approved,
    int assigned,
    int rejected,
    int completed,
    int canceled,
  }) =>
      Count(
        pending: pending ?? this.pending,
        approved: approved ?? this.approved,
        assigned: assigned ?? this.assigned,
        rejected: rejected ?? this.rejected,
        completed: completed ?? this.completed,
        canceled: canceled ?? this.canceled,
      );

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    pending: json["pending"] == null ? null : json["pending"],
    approved: json["approved"] == null ? null : json["approved"],
    assigned: json["assigned"] == null ? null : json["assigned"],
    rejected: json["rejected"] == null ? null : json["rejected"],
    completed: json["completed"] == null ? null : json["completed"],
    canceled: json["canceled"] == null ? null : json["canceled"],
  );

  Map<String, dynamic> toJson() => {
    "pending": pending == null ? null : pending,
    "approved": approved == null ? null : approved,
    "assigned": assigned == null ? null : assigned,
    "rejected": rejected == null ? null : rejected,
    "completed": completed == null ? null : completed,
    "canceled": canceled == null ? null : canceled,
  };
}

class Request {
  Request({
    this.id,
    this.shipmentId,
    this.pickUpDate,
    this.deliverDate,
    this.status,
    this.statusAsString,
    this.source,
    this.sourceDetailedAddress,
    this.sourceName,
    this.destination,
    this.destinationDetailedAddress,
    this.destinationName,
    this.truckType,
    this.accessories,
    this.productPackage,
    this.unitType,
    this.capacity,
    this.numberOfTrucks,
    this.comment,
    this.clientId,
    this.companyName,
    this.fulFilled,
    this.srcLat,
    this.srcLng,
    this.rate,
    this.ratingComment,
    this.rated,
  });

  int id;
  int shipmentId;
  DateTime pickUpDate;
  DateTime deliverDate;
  int status;
  String statusAsString;
  String source;
  String sourceDetailedAddress;
  String sourceName;
  String destination;
  String destinationDetailedAddress;
  String destinationName;
  String truckType;
  String accessories;
  String productPackage;
  String unitType;
  int capacity;
  int numberOfTrucks;
  String comment;
  String clientId;
  String companyName;
  bool fulFilled;
  double srcLat;
  double srcLng;
  int rate;
  String ratingComment;
  bool rated;

  Request copyWith({
    int id,
    int shipmentId,
    DateTime pickUpDate,
    DateTime deliverDate,
    int status,
    String statusAsString,
    String source,
    String sourceDetailedAddress,
    String sourceName,
    String destination,
    String destinationDetailedAddress,
    String destinationName,
    String truckType,
    String accessories,
    String productPackage,
    String unitType,
    int capacity,
    int numberOfTrucks,
    String comment,
    String clientId,
    String companyName,
    bool fulFilled,
    double srcLat,
    double srcLng,
    int rate,
    String ratingComment,
    bool rated,
  }) =>
      Request(
        id: id ?? this.id,
        shipmentId: shipmentId ?? this.shipmentId,
        pickUpDate: pickUpDate ?? this.pickUpDate,
        deliverDate: deliverDate ?? this.deliverDate,
        status: status ?? this.status,
        statusAsString: statusAsString ?? this.statusAsString,
        source: source ?? this.source,
        sourceDetailedAddress: sourceDetailedAddress ?? this.sourceDetailedAddress,
        sourceName: sourceName ?? this.sourceName,
        destination: destination ?? this.destination,
        destinationDetailedAddress: destinationDetailedAddress ?? this.destinationDetailedAddress,
        destinationName: destinationName ?? this.destinationName,
        truckType: truckType ?? this.truckType,
        accessories: accessories ?? this.accessories,
        productPackage: productPackage ?? this.productPackage,
        unitType: unitType ?? this.unitType,
        capacity: capacity ?? this.capacity,
        numberOfTrucks: numberOfTrucks ?? this.numberOfTrucks,
        comment: comment ?? this.comment,
        clientId: clientId ?? this.clientId,
        companyName: companyName ?? this.companyName,
        fulFilled: fulFilled ?? this.fulFilled,
        srcLat: srcLat ?? this.srcLat,
        srcLng: srcLng ?? this.srcLng,
        rate: rate ?? this.rate,
        ratingComment: ratingComment ?? this.ratingComment,
        rated: rated ?? this.rated,
      );

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"] == null ? null : json["id"],
    shipmentId: json["shipmentId"] == null ? null : json["shipmentId"],
    pickUpDate: json["pickUpDate"] == null ? null : DateTime.parse(json["pickUpDate"]),
    deliverDate: json["deliverDate"] == null ? null : DateTime.parse(json["deliverDate"]),
    status: json["status"] == null ? null : json["status"],
    statusAsString: json["statusAsString"] == null ? null : json["statusAsString"],
    source: json["source"] == null ? null : json["source"],
    sourceDetailedAddress: json["sourceDetailedAddress"] == null ? null : json["sourceDetailedAddress"],
    sourceName: json["sourceName"] == null ? null : json["sourceName"],
    destination: json["destination"] == null ? null : json["destination"],
    destinationDetailedAddress: json["destinationDetailedAddress"] == null ? null : json["destinationDetailedAddress"],
    destinationName: json["destinationName"] == null ? null : json["destinationName"],
    truckType: json["truckType"] == null ? null : json["truckType"],
    accessories: json["accessories"] == null ? null : json["accessories"],
    productPackage: json["productPackage"] == null ? null : json["productPackage"],
    unitType: json["unitType"] == null ? null : json["unitType"],
    capacity: json["capacity"] == null ? null : json["capacity"],
    numberOfTrucks: json["numberOfTrucks"] == null ? null : json["numberOfTrucks"],
    comment: json["comment"] == null ? null : json["comment"],
    clientId: json["clientId"] == null ? null : json["clientId"],
    companyName: json["companyName"] == null ? null : json["companyName"],
    fulFilled: json["fulFilled"] == null ? null : json["fulFilled"],
    srcLat: json["srcLat"] == null ? null : json["srcLat"].toDouble(),
    srcLng: json["srcLng"] == null ? null : json["srcLng"].toDouble(),
    rate: json["rate"] == null ? null : json["rate"],
    ratingComment: json["ratingComment"] == null ? null : json["ratingComment"],
    rated: json["rated"] == null ? null : json["rated"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "shipmentId": shipmentId == null ? null : shipmentId,
    "pickUpDate": pickUpDate == null ? null : pickUpDate.toIso8601String(),
    "deliverDate": deliverDate == null ? null : deliverDate.toIso8601String(),
    "status": status == null ? null : status,
    "statusAsString": statusAsString == null ? null : statusAsString,
    "source": source == null ? null : source,
    "sourceDetailedAddress": sourceDetailedAddress == null ? null : sourceDetailedAddress,
    "sourceName": sourceName == null ? null : sourceName,
    "destination": destination == null ? null : destination,
    "destinationDetailedAddress": destinationDetailedAddress == null ? null : destinationDetailedAddress,
    "destinationName": destinationName == null ? null : destinationName,
    "truckType": truckType == null ? null : truckType,
    "accessories": accessories == null ? null : accessories,
    "productPackage": productPackage == null ? null : productPackage,
    "unitType": unitType == null ? null : unitType,
    "capacity": capacity == null ? null : capacity,
    "numberOfTrucks": numberOfTrucks == null ? null : numberOfTrucks,
    "comment": comment == null ? null : comment,
    "clientId": clientId == null ? null : clientId,
    "companyName": companyName == null ? null : companyName,
    "fulFilled": fulFilled == null ? null : fulFilled,
    "srcLat": srcLat == null ? null : srcLat,
    "srcLng": srcLng == null ? null : srcLng,
    "rate": rate == null ? null : rate,
    "ratingComment": ratingComment == null ? null : ratingComment,
    "rated": rated == null ? null : rated,
  };
}
