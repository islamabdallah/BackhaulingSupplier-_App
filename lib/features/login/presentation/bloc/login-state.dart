import 'package:haulerapp/core/base_bloc/base_bloc.dart';
import 'package:haulerapp/core/errors/base_error.dart';
import 'package:haulerapp/core/errors/custom_error.dart';

class BaseLoginState {}

class LoginSuccessState extends BaseLoginState {
  LoginSuccessState();
}

class LoginLoadingState extends BaseLoginState {}

class LoginFailedState extends BaseLoginState {
  final CustomError error;
  LoginFailedState(this.error);
}