import 'package:haulerapp/core/base_bloc/base_bloc.dart';
import 'package:haulerapp/core/errors/base_error.dart';

class BaseSplashState {}

class SplashSuccessState extends BaseSplashState {
  final bool goToHomePage;
  final bool goToLoginPage;

  SplashSuccessState({this.goToLoginPage = false, this.goToHomePage = false});
}

class SplashLoadingState extends BaseSplashState {}

class SplashInitLoading extends BaseSplashState {}

class SplashFailedState extends BaseSplashState {
  final BaseError error;
  SplashFailedState(this.error);
}

