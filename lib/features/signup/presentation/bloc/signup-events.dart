import 'package:haulerapp/features/signup/data/models/registerData.dart';

class BaseSignUpEvent{}

class GetIndustryEvent extends BaseSignUpEvent{}

class  SignUpEvent extends BaseSignUpEvent {
  final RegisterModel registerModel;
  SignUpEvent({this.registerModel});
}
