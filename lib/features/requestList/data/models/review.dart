// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) => ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    this.clientId,
    this.reqId,
    this.rate,
    this.comment,
  });

  String clientId;
  int reqId;
  int rate;
  String comment;

  ReviewModel copyWith({
    String clientId,
    int reqId,
    int rate,
    String comment,
  }) =>
      ReviewModel(
        clientId: clientId ?? this.clientId,
        reqId: reqId ?? this.reqId,
        rate: rate ?? this.rate,
        comment: comment ?? this.comment,
      );

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      ReviewModel(
        clientId: json["clientId"] == null ? null : json["clientId"],
        reqId: json["reqId"] == null ? null : json["reqId"],
        rate: json["rate"] == null ? null : json["rate"],
        comment: json["comment"] == null ? null : json["comment"],
      );

  Map<String, dynamic> toJson() =>
      {
        "clientId": clientId == null ? null : clientId,
        "reqId": reqId == null ? null : reqId,
        "rate": rate == null ? null : rate,
        "comment": comment == null ? null : comment,
      };
}
