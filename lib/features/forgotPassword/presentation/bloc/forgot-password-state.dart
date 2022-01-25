import 'package:haulerapp/core/errors/custom_error.dart';

class BaseForgotPasswordState {}

class  ForgotPasswordSuccessState extends BaseForgotPasswordState {
   ForgotPasswordSuccessState();
}

class  ForgotPasswordLoadingState extends BaseForgotPasswordState {}

class  ForgotPasswordFailedState extends BaseForgotPasswordState {
  final CustomError error;
   ForgotPasswordFailedState(this.error);
}