import 'package:haulerapp/core/models/base_model.dart';

class EmptyResultModel extends BaseModel {
  EmptyResultModel();

  factory EmptyResultModel.frommJson(json) => EmptyResultModel();
}

class RemoteResultModel<Data> extends BaseModel {
  final Data data;
  final String msgEN;
  final String msgAR;
  final bool success;
  RemoteResultModel({this.data, this.msgEN, this.msgAR, this.success});
  factory RemoteResultModel.fromJson(Map<String, dynamic> json) {
    return RemoteResultModel(
      data: json['data'],
      msgEN: json['msgEN'],
      msgAR: json['msgAR'],
      success: json['success'],
    );
  }
}

