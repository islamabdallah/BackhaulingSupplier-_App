import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/features/signup/data/repositories/signup-repositories-implementation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup-events.dart';
import 'signup-state.dart';


class SignUpBloc extends Bloc<BaseSignUpEvent, BaseSignUpState> {
  SignUpBloc(BaseSignUpState initialState) : super(initialState);

  @override
  Stream<BaseSignUpState> mapEventToState(BaseSignUpEvent event) async* {
    // TODO: implement mapEventToState
    SignUpRepositoryImplementation repo = new  SignUpRepositoryImplementation();

    if(event is GetIndustryEvent){
      yield SignUpLoadingState();
      final result = await repo.getIndustryData();
      if(result.hasDataOnly){
        yield GetIndustrySuccessState(result.data);
      } else {
        final CustomError error = result.error;
        yield SignUpFailedState(error);
      }
    } else if (event is  SignUpEvent) {
      yield  SignUpLoadingState();
      final res = await repo.signUpUser(event.registerModel);
      if (res.hasErrorOnly) {
        final CustomError error = res.error;
        yield  SignUpFailedState(error);
      } else {
        yield  SignUpSuccessState(successData: res.data);
      }
    }
  }
}
