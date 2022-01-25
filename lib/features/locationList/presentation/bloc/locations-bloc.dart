import 'package:haulerapp/features/locationList/data/repositories/location-list-repositories-implementation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'locations-events.dart';
import 'locations-state.dart';

class LocationsBloc extends Bloc<BaseLocationsEvent, BaseLocationsState> {
  LocationsBloc(BaseLocationsState initialState) : super(initialState);

  @override
  Stream<BaseLocationsState> mapEventToState(BaseLocationsEvent event) async* {

    LocationListRepositoryImplementation repo = new LocationListRepositoryImplementation();

    if(event is GetLocationsDataEvent){
      yield LocationsLoadingState();
      final result = await repo.getLocationListData();
      if(result.hasDataOnly){
        yield LocationsSuccessState(locationsData:result.data);
      }else{
        yield LocationsFailedState(result.error);
      }

    }
  }
}
