import 'dart:convert';

DriverModel driverModelFromJson(String str) => DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  DriverModel({
    this.id,
    this.driverId,
    this.barCode,
    this.name,
    this.userName,
    this.password,
  });

  int id;
  String driverId;
  String barCode;
  String name;
  String userName;
  String password;

  DriverModel copyWith({
    int id,
    String driverId,
    String barCode,
    String name,
    String userName,
    String password,
  }) =>
      DriverModel(
        id: id ?? this.id,
        driverId: driverId ?? this.driverId,
        barCode: barCode ?? this.barCode,
        name: name ?? this.name,
        userName: userName ?? this.userName,
        password: password ?? this.password,
      );

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    id: json["id"] == null ? null : json["id"],
    driverId: json["driverID"] == null ? null : json["driverID"],
    barCode: json["barCode"] == null ? null : json["barCode"],
    name: json["name"] == null ? null : json["name"],
    userName: json["userName"] == null ? null : json["userName"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "driverID": driverId == null ? null : driverId,
    "barCode": barCode == null ? null : barCode,
    "name": name == null ? null : name,
    "userName": userName == null ? null : userName,
    "password": password == null ? null : password,
  };
}
