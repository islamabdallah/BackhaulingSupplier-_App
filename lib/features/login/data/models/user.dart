import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.companyName,
    this.companyPhone,
    this.companyAddress,
    this.contactName,
    this.contactPhone,
    this.industryId,
    this.status,
    this.industry,
    this.isActive,
    this.id,
    this.userName,
    this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    this.emailConfirmed,
    this.password,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
  });

  String companyName;
  String companyPhone;
  String companyAddress;
  String contactName;
  String contactPhone;
  int industryId;
  String status;
  String industry;
  bool isActive;
  String id;
  String userName;
  String normalizedUserName;
  String email;
  String normalizedEmail;
  bool emailConfirmed;
  String password;
  String securityStamp;
  String concurrencyStamp;
  String phoneNumber;
  bool phoneNumberConfirmed;
  bool twoFactorEnabled;
  String lockoutEnd;
  bool lockoutEnabled;
  int accessFailedCount;

  UserModel copyWith({
    String companyName,
    String companyPhone,
    String companyAddress,
    String contactName,
    String contactPhone,
    int industryId,
    String status,
    String industry,
    bool isActive,
    String id,
    String userName,
    String normalizedUserName,
    String email,
    String normalizedEmail,
    bool emailConfirmed,
    String password,
    String securityStamp,
    String concurrencyStamp,
    String phoneNumber,
    bool phoneNumberConfirmed,
    bool twoFactorEnabled,
    String lockoutEnd,
    bool lockoutEnabled,
    int accessFailedCount,
  }) =>
      UserModel(
        companyName: companyName ?? this.companyName,
        companyPhone: companyPhone ?? this.companyPhone,
        companyAddress: companyAddress ?? this.companyAddress,
        contactName: contactName ?? this.contactName,
        contactPhone: contactPhone ?? this.contactPhone,
        industryId: industryId ?? this.industryId,
        status: status ?? this.status,
        industry: industry ?? this.industry,
        isActive: isActive ?? this.isActive,
        id: id ?? this.id,
        userName: userName ?? this.userName,
        normalizedUserName: normalizedUserName ?? this.normalizedUserName,
        email: email ?? this.email,
        normalizedEmail: normalizedEmail ?? this.normalizedEmail,
        emailConfirmed: emailConfirmed ?? this.emailConfirmed,
        password: password ?? this.password,
        securityStamp: securityStamp ?? this.securityStamp,
        concurrencyStamp: concurrencyStamp ?? this.concurrencyStamp,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneNumberConfirmed: phoneNumberConfirmed ?? this.phoneNumberConfirmed,
        twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
        lockoutEnd: lockoutEnd ?? this.lockoutEnd,
        lockoutEnabled: lockoutEnabled ?? this.lockoutEnabled,
        accessFailedCount: accessFailedCount ?? this.accessFailedCount,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    companyName: json["companyName"] == null ? null : json["companyName"],
    companyPhone: json["companyPhone"] == null ? null : json["companyPhone"],
    companyAddress: json["companyAddress"] == null ? null : json["companyAddress"],
    contactName: json["contactName"] == null ? null : json["contactName"],
    contactPhone: json["contactPhone"] == null ? null : json["contactPhone"],
    industryId: json["industryId"] == null ? null : json["industryId"],
    status: json["status"] == null ? null : json["status"],
    industry: json["industry"] == null ? null : json["industry"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    id: json["id"] == null ? null : json["id"],
    userName: json["userName"] == null ? null : json["userName"],
    normalizedUserName: json["normalizedUserName"] == null ? null : json["normalizedUserName"],
    email: json["email"] == null ? null : json["email"],
    normalizedEmail: json["normalizedEmail"] == null ? null : json["normalizedEmail"],
    emailConfirmed: json["emailConfirmed"] == null ? null : json["emailConfirmed"],
    password: json["password"] == null ? null : json["password"],
    securityStamp: json["securityStamp"] == null ? null : json["securityStamp"],
    concurrencyStamp: json["concurrencyStamp"] == null ? null : json["concurrencyStamp"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"] == null ? null : json["phoneNumberConfirmed"],
    twoFactorEnabled: json["twoFactorEnabled"] == null ? null : json["twoFactorEnabled"],
    lockoutEnd: json["lockoutEnd"] == null ? null : json["lockoutEnd"],
    lockoutEnabled: json["lockoutEnabled"] == null ? null : json["lockoutEnabled"],
    accessFailedCount: json["accessFailedCount"] == null ? null : json["accessFailedCount"],
  );
  factory UserModel.fromSqlJson(Map<String, dynamic> json) => UserModel(
    companyName: json["companyName"] == null ? null : json["companyName"],
    companyPhone: json["companyPhone"] == null ? null : json["companyPhone"],
    companyAddress: json["companyAddress"] == null ? null : json["companyAddress"],
    contactName: json["contactName"] == null ? null : json["contactName"],
    contactPhone: json["contactPhone"] == null ? null : json["contactPhone"],
    industryId: json["industryId"] == null ? null : json["industryId"],
    status: json["status"] == null ? null : json["status"],
    industry: json["industry"] == null ? null : json["industry"],
    isActive: json["isActive"] == null ? null : json["isActive"] == 1 ? true: false,
    id: json["id"] == null ? null : json["id"],
    userName: json["userName"] == null ? null : json["userName"],
    normalizedUserName: json["normalizedUserName"] == null ? null : json["normalizedUserName"],
    email: json["email"] == null ? null : json["email"],
    normalizedEmail: json["normalizedEmail"] == null ? null : json["normalizedEmail"],
    emailConfirmed: json["emailConfirmed"] == null ? null : json["emailConfirmed"],
    password: json["password"] == null ? null : json["password"],
    securityStamp: json["securityStamp"] == null ? null : json["securityStamp"],
    concurrencyStamp: json["concurrencyStamp"] == null ? null : json["concurrencyStamp"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"] == null ? null : json["phoneNumberConfirmed"],
    twoFactorEnabled: json["twoFactorEnabled"] == null ? null : json["twoFactorEnabled"],
    lockoutEnd: json["lockoutEnd"] == null ? null : json["lockoutEnd"],
    lockoutEnabled: json["lockoutEnabled"] == null ? null : json["lockoutEnabled"],
    accessFailedCount: json["accessFailedCount"] == null ? null : json["accessFailedCount"],
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName == null ? null : companyName,
    "companyPhone": companyPhone == null ? null : companyPhone,
    "companyAddress": companyAddress == null ? null : companyAddress,
    "contactName": contactName == null ? null : contactName,
    "contactPhone": contactPhone == null ? null : contactPhone,
    "industryId": industryId == null ? null : industryId,
    "status": status == null ? null : status,
    "industry": industry == null ? null : industry,
    "isActive": isActive == null ? null : isActive,
    "id": id == null ? null : id,
    "userName": userName == null ? null : userName,
    "normalizedUserName": normalizedUserName == null ? null : normalizedUserName,
    "email": email == null ? null : email,
    "normalizedEmail": normalizedEmail == null ? null : normalizedEmail,
    "emailConfirmed": emailConfirmed == null ? null : emailConfirmed,
    "password": password == null ? null : password,
    "securityStamp": securityStamp == null ? null : securityStamp,
    "concurrencyStamp": concurrencyStamp == null ? null : concurrencyStamp,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "phoneNumberConfirmed": phoneNumberConfirmed == null ? null : phoneNumberConfirmed,
    "twoFactorEnabled": twoFactorEnabled == null ? null : twoFactorEnabled,
    "lockoutEnd": lockoutEnd == null ? null : lockoutEnd,
    "lockoutEnabled": lockoutEnabled == null ? null : lockoutEnabled,
    "accessFailedCount": accessFailedCount == null ? null : accessFailedCount,
  };
}
