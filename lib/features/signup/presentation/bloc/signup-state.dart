import 'package:haulerapp/core/errors/custom_error.dart';

class BaseSignUpState {}

class  SignUpSuccessState extends BaseSignUpState {
  dynamic successData;
   SignUpSuccessState({this.successData});
}

class  SignUpLoadingState extends BaseSignUpState {}

class  SignUpFailedState extends BaseSignUpState {
  final CustomError error;
   SignUpFailedState(this.error);
}

class GetIndustrySuccessState extends BaseSignUpState {

  dynamic industryData;

  GetIndustrySuccessState(this.industryData);
}