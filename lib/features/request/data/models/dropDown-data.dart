// To parse this JSON data, do
//
//     final dropDownDataModel = dropDownDataModelFromJson(jsonString);

import 'dart:convert';

DropDownDataModel dropDownDataModelFromJson(String str) => DropDownDataModel.fromJson(json.decode(str));

String dropDownDataModelToJson(DropDownDataModel data) => json.encode(data.toJson());

class DropDownDataModel {
  DropDownDataModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.active,
  });

  int id;
  String nameEn;
  String nameAr;
  bool active;

  DropDownDataModel copyWith({
    int id,
    String nameEn,
    String nameAr,
    bool active,
  }) =>
      DropDownDataModel(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        active: active ?? this.active,
      );

  factory DropDownDataModel.fromJson(Map<String, dynamic> json) => DropDownDataModel(
    id: json["id"] == null ? null : json["id"],
    nameEn: json["nameEN"] == null ? null : json["nameEN"],
    nameAr: json["nameAR"] == null ? null : json["nameAR"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "nameEN": nameEn == null ? null : nameEn,
    "nameAR": nameAr == null ? null : nameAr,
    "active": active == null ? null : active,
  };
}
