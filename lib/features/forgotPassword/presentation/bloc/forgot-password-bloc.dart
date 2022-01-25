import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/features/forgotPassword/data/repositories/forgot-password-repositories-implementation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/core/base_bloc/base_bloc.dart';
import 'forgot-password-events.dart';
import 'forgot-password-state.dart';


class ForgotPasswordBloc extends Bloc<BaseEvent, BaseForgotPasswordState> {
  ForgotPasswordBloc(BaseForgotPasswordState initialState) : super(initialState);

  @override
  Stream<BaseForgotPasswordState> mapEventToState(BaseEvent event) async* {
    // TODO: implement mapEventToState
    ForgotPasswordRepositoryImplementation repo = new  ForgotPasswordRepositoryImplementation();

    if (event is  ForgotPasswordEvent) {
      yield  ForgotPasswordLoadingState();
      final res = await repo. forgotPasswordUser(event.userModel);
      if (res.hasErrorOnly) {
        final CustomError error = res.error;
        yield  ForgotPasswordFailedState(error);
      } else {
        yield  ForgotPasswordSuccessState();
      }
    }
  }
}
