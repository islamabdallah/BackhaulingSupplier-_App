import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/core/base_bloc/base_bloc.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/services/local_storage/local_storage_service.dart';
import 'package:haulerapp/features/login/data/repositories/user-repositories-implementation.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-events.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-state.dart';

class LoginBloc extends Bloc<BaseEvent, BaseLoginState> {
  LoginBloc(BaseLoginState initialState) : super(initialState);

  @override
  Stream<BaseLoginState> mapEventToState(BaseEvent event) async* {
    // TODO: implement mapEventToState
    LoginRepositoryImplementation repo = new LoginRepositoryImplementation();
    LocalStorageService localStorage = LocalStorageService();

    if (event is LoginEvent) {
      yield LoginLoadingState();
      final res = await repo.loginUser(event.userModel);
      if (res.hasErrorOnly) {
        print('${res.error}');
        final CustomError error = res.error ;
        yield LoginFailedState(error);
      } else {
        /// Save Current Trip Data

        yield LoginSuccessState();
      }
    }
  }
}
