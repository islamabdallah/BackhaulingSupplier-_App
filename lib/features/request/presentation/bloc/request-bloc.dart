import 'package:haulerapp/features/request/data/repositories/request-repositories-implementation.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-events.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestBloc extends Bloc<BaseRequestEvent, BaseRequestState> {
  RequestBloc(BaseRequestState initialState) : super(initialState);

  @override
  Stream<BaseRequestState> mapEventToState(BaseRequestEvent event) async* {

    RequestRepositoryImplementation repo = new RequestRepositoryImplementation();

    if(event is GetRequestFormDataEvent){
      yield RequestLoadingState();

      final result = await repo.getRequestData();

      if(result.hasDataOnly){
        print(result.data.locations.first.longitude);
        yield RequestSuccessState(requestFormData:result.data);
      }else{
        yield RequestFailedState(result.error);
      }

    } else if(event is SaveRequestEvent) {
      yield RequestLoadingState();
      final res = await repo.saveRequestData(event.requestModel);
      if(res.hasErrorOnly) {
        yield RequestFailedState(res.error);
      } else {
        yield RequestSaveState();
      }
    }
  }
}
