import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/features/splsh/presentation/bloc/splash-state.dart';
import 'package:haulerapp/features/splsh/presentation/bloc/splash-event.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';


class SplashBloc extends Bloc<BaseSplashEvent, BaseSplashState> {
  SplashBloc(BaseSplashState initialState) : super(initialState);

  @override
  Stream<BaseSplashState> mapEventToState(BaseSplashEvent event) async* {
    // TODO: implement mapEventToState
    final dataDB =  await DBHelper.getData('cemex_user');
    try {
       if(event is GetSplashEvent){
        yield SplashLoadingState();
       print(dataDB.length);
        if(dataDB.length == 0) {
          print("seen is false: ");
          yield SplashSuccessState(goToHomePage: false, goToLoginPage: true);
        } else {
          yield SplashSuccessState(goToLoginPage: false, goToHomePage: true);

        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
