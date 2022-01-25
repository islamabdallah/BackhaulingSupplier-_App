// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.compnayName,
    this.compnayPhone,
    this.contactName,
    this.compnayAddress,
    this.contactPhone,
    this.industryId,
    this.newIndustry,
    this.email,
    this.password,
  });

  String compnayName;
  String compnayPhone;
  String contactName;
  String compnayAddress;
  String contactPhone;
  int industryId;
  String newIndustry;
  String email;
  String password;

  RegisterModel copyWith({
    String compnayName,
    String compnayPhone,
    String contactName,
    String compnayAddress,
    String contactPhone,
    int industryId,
    String newIndustry,
    String email,
    String password,
  }) =>
      RegisterModel(
        compnayName: compnayName ?? this.compnayName,
        compnayPhone: compnayPhone ?? this.compnayPhone,
        contactName: contactName ?? this.contactName,
        compnayAddress: compnayAddress ?? this.compnayAddress,
        contactPhone: contactPhone ?? this.contactPhone,
        industryId: industryId ?? this.industryId,
        newIndustry: newIndustry ?? this.newIndustry,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    compnayName: json["CompnayName"] == null ? null : json["CompnayName"],
    compnayPhone: json["CompnayPhone"] == null ? null : json["CompnayPhone"],
    contactName: json["ContactName"] == null ? null : json["ContactName"],
    compnayAddress: json["CompnayAddress"] == null ? null : json["CompnayAddress"],
    contactPhone: json["ContactPhone"] == null ? null : json["ContactPhone"],
    industryId: json["IndustryId"] == null ? null : json["IndustryId"],
    newIndustry: json["NewIndustry"] == null ? null : json["NewIndustry"],
    email: json["Email"] == null ? null : json["Email"],
    password: json["Password"] == null ? null : json["Password"],
  );

  Map<String, dynamic> toJson() => {
    "CompnayName": compnayName == null ? null : compnayName,
    "CompnayPhone": compnayPhone == null ? null : compnayPhone,
    "ContactName": contactName == null ? null : contactName,
    "CompnayAddress": compnayAddress == null ? null : compnayAddress,
    "ContactPhone": contactPhone == null ? null : contactPhone,
    "IndustryId": industryId == null ? null : industryId,
    "NewIndustry": newIndustry == null ? null : newIndustry,
    "Email": email == null ? null : email,
    "Password": password == null ? null : password,
  };
}
