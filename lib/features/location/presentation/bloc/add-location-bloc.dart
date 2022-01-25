import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/features/location/data/repositories/add-location-repositories-implementation.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add-location-events.dart';
import 'add-location-state.dart';

class AddLocationBloc extends Bloc<BaseLocationEvent, BaseLocationState> {
  AddLocationBloc(BaseLocationState initialState) : super(initialState);

  @override
  Stream<BaseLocationState> mapEventToState(BaseLocationEvent event) async* {

    AddLocationRepositoryImplementation repo = new AddLocationRepositoryImplementation();

    if(event is GetAreaDataEvent){
      yield LocationLoadingState();

      final result = await repo.getLocationRequestData();

      if(result.hasDataOnly){
        print(result.data);
        yield LocationSuccessState(requestFormData:result.data);
      }else{
        final CustomError error = result.error;
        yield LocationFailedState(error);
      }

    } else if(event is SaveLocationEvent) {
      yield LocationLoadingState();
      final res = await repo.saveLocationData(event.requestModel);
      if(res.hasErrorOnly) {
        final CustomError error = res.error ;
        yield LocationFailedState(error);
      } else {
        yield LocationSaveState();
      }
    }
  }
}
