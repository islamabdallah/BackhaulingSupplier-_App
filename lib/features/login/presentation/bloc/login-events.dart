import 'package:haulerapp/core/base_bloc/base_bloc.dart';
import 'package:haulerapp/features/login/data/models/user.dart';

class LoginEvent extends BaseEvent {
  final UserModel userModel;
  LoginEvent({this.userModel});
}
