import 'package:haulerapp/core/errors/base_error.dart';
import 'package:haulerapp/features/request/data/models/request.dart';

class BaseRequestState {}

class RequestSuccessState extends BaseRequestState {

  dynamic requestFormData;

  RequestSuccessState({this.requestFormData});
}

class RequestLoadingState extends BaseRequestState {}

class RequestInitLoading extends BaseRequestState {}

class RequestFailedState extends BaseRequestState {
  final BaseError error;
  RequestFailedState(this.error);
}

class RequestSaveState extends BaseRequestState {}
