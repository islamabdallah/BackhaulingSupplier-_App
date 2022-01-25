import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'core/services/navigation_service/navigation_service.dart';
import 'core/sqllite/sqlite_api.dart';
import 'features/forgotPassword/presentation/pages/forgot-password-page.dart';
import 'features/home.dart';
import 'features/location/presentation/pages/location-page.dart';
import 'features/locationList/presentation/pages/locations-page.dart';
import 'features/login/presentation/pages/login-page.dart';
import 'features/profile/presentation/pages/profile.dart';
import 'features/request/presentation/pages/request-page.dart';
import 'features/requestList/presentation/pages/request-list.dart';
import 'features/signup/presentation/pages/signup-page.dart';
import 'features/splsh/presentation/pages/splash-page.dart';
import 'features/trips/presentation/pages/trips.dart';
import 'package:in_app_update/in_app_update.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
    apiKeyGoogle: '<Key>', // NOT YET TESTED
  ); // intialize

  runApp(LocalizedApp(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((_updateInfo) {
      print(UpdateAvailability.updateAvailable);
      print(_updateInfo);
      if ( _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((error) => print(error));
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }
  @override
  void initState() {
    checkForUpdate();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget  build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: translator.delegates,
      locale: translator.locale,
      supportedLocales: translator.locals(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute:  SplashWidget.routeName,
        // onGenerateRoute: gNavigationService.onGenerateRoute,
        // navigatorKey: gNavigationService.navigationKey,
//        onGenerateRoute: gNavigationService.onGenerateRoute,
//        navigatorKey: gNavigationService.navigationKey,
        routes: {
            SplashWidget.routeName: (context) => SplashWidget(),
            LoginWidget.routeName: (context) => LoginWidget(),
            SignUpWidget.routeName: (context) => SignUpWidget(),
//            ForgotPasswordWidget.routeName: (context) => ForgotPasswordWidget(),
//            RequestWidget.routeName: (context) => RequestWidget(),
            HomeWidget.routeName: (context) => HomeWidget(),
            LocationsWidget.routeName: (context) =>LocationsWidget(),
//            LocationWidget.routeName: (context) =>LocationWidget(),
            RequestListWidget.routeName: (context) => RequestListWidget(),
            TripsWidget.routeName: (context) => TripsWidget(), //map
            ProfileWidget.routeName: (context) => ProfileWidget(),
        }
    );
  }
}




