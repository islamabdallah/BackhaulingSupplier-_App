import 'package:haulerapp/features/requestList/data/models/request-list-data.dart';
import 'package:haulerapp/features/requestList/data/models/review.dart';

class BaseRequestListEvent{}

class GetPendingDataEvent extends BaseRequestListEvent{}
class GetApprovedDataEvent extends BaseRequestListEvent{}
class GetAssignedDataEvent extends BaseRequestListEvent{}
class GetRejectedDataEvent extends BaseRequestListEvent{}
class GetCompletedDataEvent extends BaseRequestListEvent{}
class GetCanceledDataEvent extends BaseRequestListEvent{}
class CancelRequestEvent extends BaseRequestListEvent {
  final Request requestModel;
  CancelRequestEvent(this.requestModel);
}
class ReviewRequestEvent extends BaseRequestListEvent {
  final ReviewModel reviewData;
  ReviewRequestEvent(this.reviewData);
}