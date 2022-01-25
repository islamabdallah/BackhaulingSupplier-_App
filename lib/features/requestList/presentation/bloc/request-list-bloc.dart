import 'package:haulerapp/core/errors/custom_error.dart';
import 'package:haulerapp/features/requestList/data/repositories/request-list-repositories-implementation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'request-list-events.dart';
import 'request-list-state.dart';

class RequestListBloc extends Bloc<BaseRequestListEvent, BaseRequestListState> {
  RequestListBloc(BaseRequestListState initialState) : super(initialState);

  @override
  Stream<BaseRequestListState> mapEventToState(BaseRequestListEvent event) async* {

    RequestListRepositoryImplementation repo = new RequestListRepositoryImplementation();

    if(event is GetPendingDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Pending');
      if(result.hasDataOnly){
        print(result.data);
        yield PendingListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }
    else if(event is GetApprovedDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Approved');
      if(result.hasDataOnly){
        print(result.data);
        yield ApprovedListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }
    else if(event is GetAssignedDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Assigned');
      if(result.hasDataOnly){
        print(result.data);
        yield AssignedListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }
    else if(event is GetRejectedDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Rejected');
      if(result.hasDataOnly){
        print(result.data);
        yield RejectedListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }
    else if(event is GetCompletedDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Completed');
      if(result.hasDataOnly){
        print(result.data);
        yield CompletedListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }
    else if(event is GetCanceledDataEvent){
      yield RequestListLoadingState();
      final result = await repo.getRequestListData('Canceled');
      if(result.hasDataOnly){
        print(result.data);
        yield CanceledListSuccessState(result.data);
      }else{
        final CustomError error = result.error;
        yield RequestListFailedState(error);
      }

    }

    else if(event is CancelRequestEvent) {
      yield RequestListLoadingState();
      final res = await repo.cancelRequest(event.requestModel);
      if(res.hasErrorOnly) {
        final CustomError error = res.error;
        yield RequestReviewORCancelFailedState(error);
      } else {
        yield CancelRequestSuccessState(successData: res.data);
      }
    }
    else if(event is ReviewRequestEvent) {
      yield RequestListLoadingState();
      final res = await repo.reviewRequest(event.reviewData);
      if(res.hasErrorOnly) {
        final CustomError error = res.error;
        yield RequestReviewORCancelFailedState(error);
      } else {
        yield ReviewRequestSuccessState(successData: res.data);
      }
    }
  }
}
