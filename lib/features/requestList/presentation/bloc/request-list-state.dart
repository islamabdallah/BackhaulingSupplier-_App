import 'package:haulerapp/core/errors/base_error.dart';
import 'package:haulerapp/core/errors/custom_error.dart';

class BaseRequestListState {}

class RequestListSuccessState extends BaseRequestListState {
  dynamic requestListData;
  RequestListSuccessState(this.requestListData);
}
class PendingListSuccessState extends RequestListSuccessState {
  PendingListSuccessState(requestListData) : super(requestListData);
}
class ApprovedListSuccessState extends RequestListSuccessState {
  ApprovedListSuccessState(requestListData) : super(requestListData);
}
class AssignedListSuccessState extends RequestListSuccessState {
  AssignedListSuccessState(requestListData) : super(requestListData);
}
class RejectedListSuccessState extends RequestListSuccessState {
  RejectedListSuccessState(requestListData) : super(requestListData);
}
class CompletedListSuccessState extends RequestListSuccessState {
  CompletedListSuccessState(requestListData) : super(requestListData);
}
class CanceledListSuccessState extends RequestListSuccessState {
  CanceledListSuccessState(requestListData) : super(requestListData);
}
class RequestListLoadingState extends BaseRequestListState {}
class RequestListInitLoading extends BaseRequestListState {}
class RequestListFailedState extends BaseRequestListState {
  final CustomError error;
  RequestListFailedState(this.error);
}
class CancelRequestSuccessState extends BaseRequestListState {
 final dynamic successData;
 CancelRequestSuccessState({this.successData});
}
class ReviewRequestSuccessState extends BaseRequestListState {
  final dynamic successData;
  ReviewRequestSuccessState({this.successData});
}
class RequestReviewORCancelFailedState extends BaseRequestListState {
  final CustomError error;
  RequestReviewORCancelFailedState(this.error);
}
